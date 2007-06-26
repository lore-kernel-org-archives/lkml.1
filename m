Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbXFZWLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbXFZWLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbXFZWLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:11:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57705 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254AbXFZWLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:11:37 -0400
Date: Tue, 26 Jun 2007 23:11:34 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Josh Triplett <josh@freedesktop.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070626221134.GA21350@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626221040.GI21478@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, here's the replacement.  First the handling of __builtin_offsetof()
> (below in this mail), then integer constant expressions (in followup).

>From a24a3adf3f0e3c22b0d98837090c55307f6fec84 Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sun, 24 Jun 2007 03:11:14 -0400
Subject: [PATCH] fix handling of integer constant expressions

Hopefully correct handling of integer constant expressions.  Please, review.

Rules:
        * two new flags for expression: int_const_expr and float_literal.
        * parser sets them by the following rules:
                * EXPR_FVALUE gets float_literal
                * EXPR_VALUE gets int_const_expr
                * EXPR_PREOP[(] inherits from argument
                * EXPR_SIZEOF, EXPR_PTRSIZEOF, EXPR_ALIGNOF get int_const_expr
                * EXPR_BINOP, EXPR_COMPARE, EXPR_LOGICAL, EXPR_CONDITIONAL,
                  EXPR_PREOP[+,-,!,~]: get marked int_const_expr if all their
                  arguments are marked that way
                * EXPR_CAST gets marked int_const_expr if argument is marked
                  that way; if argument is marked float_literal but not
                  int_const_expr, we get both flags set.
                * EXPR_TYPE also gets marked int_const_expr (to make it DTRT
                  on the builtin_same_type_p() et.al.)
		* EXPR_OFFSETOF gets marked int_const_expr
When we get an expression from parser, we know that having int_const_expr on
it is almost equivalent to "it's an integer constant expression".  Indeed,
the only checks we still have not done are that all casts present in there
are to integer types, that expression is correctly typed and that all indices
in offsetof are integer constant expressions.  That belongs to evaluate_expression()
and is easily done there.
        * evaluate_expression() removes int_const_expr from some nodes:
                * EXPR_BINOP, EXPR_COMPARE, EXPR_LOGICAL, EXPR_CONDITIONAL,
                  EXPR_PREOP: if the node is marked int_const_expr and some
                  of its arguments are not marked that way once we have
                  done evaluate_expression() on them, unmark our node.
                * EXPR_IMLICIT_CAST: inherit flags from argument.
                * cannibalizing nodes in *& and &* simplifications: unmark
                  the result.
                * EXPR_CAST: unmark if we are casting not to an integer type.
                  Unmark if argument is not marked with int_const_expr after
                  evaluate_expression() on it *and* our node is not marked
                  float_literal (i.e. (int)0.0 is fine with us).
		* EXPR_BINOP created (or cannibalizing EXPR_OFFSETOF) by
		  evaluation of evaluate_offsetof() get int_const_expr
		  if both arguments (already typechecked) have int_const_expr.
                * unmark node when we declare it mistyped.

That does it - after evaluate_expression() we keep int_const_expr only if
expression was a valid integer constant expression.

Remaining issue: VLA handling.  Right now sparse doesn't deal with those in
any sane way, but once we start handling their sizeof, we'll need to check
that type is constant-sized before marking EXPR_SIZEOF int_const_expr.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 evaluate.c   |   43 ++++++++++++++++++++++++++++++++++++
 expand.c     |   16 ++++++++++++-
 expression.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 expression.h |    9 ++++++-
 parse.c      |   10 ++++----
 5 files changed, 133 insertions(+), 13 deletions(-)

diff --git a/evaluate.c b/evaluate.c
index c702ac4..bcac1d2 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -311,6 +311,7 @@ static struct expression * cast_to(struct expression *old, struct symbol *type)
 	}
 
 	expr = alloc_expression(old->pos, EXPR_IMPLIED_CAST);
+	expr->flags = old->flags;
 	expr->ctype = type;
 	expr->cast_type = type;
 	expr->cast_expression = old;
@@ -403,6 +404,7 @@ static struct symbol *bad_expr_type(struct expression *expr)
 		break;
 	}
 
+	expr->flags = 0;
 	return expr->ctype = &bad_ctype;
 }
 
@@ -880,6 +882,10 @@ static struct symbol *evaluate_logical(struct expression *expr)
 		return NULL;
 
 	expr->ctype = &bool_ctype;
+	if (expr->flags) {
+		if (!(expr->left->flags & expr->right->flags & Int_const_expr))
+			expr->flags = 0;
+	}
 	return &bool_ctype;
 }
 
@@ -890,6 +896,11 @@ static struct symbol *evaluate_binop(struct expression *expr)
 	int rclass = classify_type(expr->right->ctype, &rtype);
 	int op = expr->op;
 
+	if (expr->flags) {
+		if (!(expr->left->flags & expr->right->flags & Int_const_expr))
+			expr->flags = 0;
+	}
+
 	/* number op number */
 	if (lclass & rclass & TYPE_NUM) {
 		if ((lclass | rclass) & TYPE_FLOAT) {
@@ -968,6 +979,11 @@ static struct symbol *evaluate_compare(struct expression *expr)
 	struct symbol *ctype;
 	int lclass, rclass;
 
+	if (expr->flags) {
+		if (!(expr->left->flags & expr->right->flags & Int_const_expr))
+			expr->flags = 0;
+	}
+
 	/* Type types? */
 	if (is_type_type(ltype) && is_type_type(rtype))
 		goto OK;
@@ -1057,6 +1073,13 @@ static struct symbol *evaluate_conditional_expression(struct expression *expr)
 		true = &expr->cond_true;
 	}
 
+	if (expr->flags) {
+		int flags = expr->conditional->flags & Int_const_expr;
+		flags &= (*true)->flags & expr->cond_false->flags;
+		if (!flags)
+			expr->flags = 0;
+	}
+
 	lclass = classify_type(ltype, &ltype);
 	rclass = classify_type(rtype, &rtype);
 	if (lclass & rclass & TYPE_NUM) {
@@ -1436,6 +1459,7 @@ static struct symbol *evaluate_addressof(struct expression *expr)
 	}
 	ctype = op->ctype;
 	*expr = *op->unop;
+	expr->flags = 0;
 
 	if (expr->type == EXPR_SYMBOL) {
 		struct symbol *sym = expr->symbol;
@@ -1463,6 +1487,7 @@ static struct symbol *evaluate_dereference(struct expression *expr)
 	/* Simplify: *&(expr) => (expr) */
 	if (op->type == EXPR_PREOP && op->op == '&') {
 		*expr = *op->unop;
+		expr->flags = 0;
 		return expr->ctype;
 	}
 
@@ -1540,6 +1565,8 @@ static struct symbol *evaluate_postop(struct expression *expr)
 static struct symbol *evaluate_sign(struct expression *expr)
 {
 	struct symbol *ctype = expr->unop->ctype;
+	if (expr->flags && !(expr->unop->flags & Int_const_expr))
+		expr->flags = 0;
 	if (is_int_type(ctype)) {
 		struct symbol *rtype = rtype = integer_promotion(ctype);
 		expr->unop = cast_to(expr->unop, rtype);
@@ -1588,6 +1615,8 @@ static struct symbol *evaluate_preop(struct expression *expr)
 		return evaluate_postop(expr);
 
 	case '!':
+		if (expr->flags && !(expr->unop->flags & Int_const_expr))
+			expr->flags = 0;
 		if (is_safe_type(ctype))
 			warning(expr->pos, "testing a 'safe expression'");
 		if (is_float_type(ctype)) {
@@ -2477,6 +2506,15 @@ static struct symbol *evaluate_cast(struct expression *expr)
 	degenerate(target);
 
 	class1 = classify_type(ctype, &t1);
+
+	/* cast to non-integer type -> not an integer constant expression */
+	if (!is_int(class1))
+		expr->flags = 0;
+	/* if argument turns out to be not an integer constant expression *and*
+	   it was not a floating literal to start with -> too bad */
+	else if (expr->flags == Int_const_expr &&
+		!(target->flags & Int_const_expr))
+		expr->flags = 0;
 	/*
 	 * You can always throw a value away by casting to
 	 * "void" - that's an implicit "force". Note that
@@ -2635,6 +2673,7 @@ static struct symbol *evaluate_offsetof(struct expression *expr)
 		}
 		ctype = field;
 		expr->type = EXPR_VALUE;
+		expr->flags = Int_const_expr;
 		expr->value = offset;
 		expr->ctype = size_t_ctype;
 	} else {
@@ -2651,6 +2690,7 @@ static struct symbol *evaluate_offsetof(struct expression *expr)
 		ctype = ctype->ctype.base_type;
 		if (!expr->index) {
 			expr->type = EXPR_VALUE;
+			expr->flags = Int_const_expr;
 			expr->value = 0;
 			expr->ctype = size_t_ctype;
 		} else {
@@ -2666,11 +2706,13 @@ static struct symbol *evaluate_offsetof(struct expression *expr)
 			m = alloc_const_expression(expr->pos,
 						   ctype->bit_size >> 3);
 			m->ctype = size_t_ctype;
+			m->flags = Int_const_expr;
 			expr->type = EXPR_BINOP;
 			expr->left = idx;
 			expr->right = m;
 			expr->op = '*';
 			expr->ctype = size_t_ctype;
+			expr->flags = m->flags & idx->flags & Int_const_expr;
 		}
 	}
 	if (e) {
@@ -2681,6 +2723,7 @@ static struct symbol *evaluate_offsetof(struct expression *expr)
 		if (!evaluate_expression(e))
 			return NULL;
 		expr->type = EXPR_BINOP;
+		expr->flags = e->flags & copy->flags & Int_const_expr;
 		expr->op = '+';
 		expr->ctype = size_t_ctype;
 		expr->left = copy;
diff --git a/expand.c b/expand.c
index c6d188e..f945518 100644
--- a/expand.c
+++ b/expand.c
@@ -1144,7 +1144,7 @@ static int expand_statement(struct statement *stmt)
 	return SIDE_EFFECTS;
 }
 
-long long get_expression_value(struct expression *expr)
+static long long __get_expression_value(struct expression *expr, int strict)
 {
 	long long value, mask;
 	struct symbol *ctype;
@@ -1161,6 +1161,10 @@ long long get_expression_value(struct expression *expr)
 		expression_error(expr, "bad constant expression");
 		return 0;
 	}
+	if (strict && !(expr->flags & Int_const_expr)) {
+		expression_error(expr, "bad integer constant expression");
+		return 0;
+	}
 
 	value = expr->value;
 	mask = 1ULL << (ctype->bit_size-1);
@@ -1173,3 +1177,13 @@ long long get_expression_value(struct expression *expr)
 	}
 	return value;
 }
+
+long long get_expression_value(struct expression *expr)
+{
+	return __get_expression_value(expr, 0);
+}
+
+long long const_expression_value(struct expression *expr)
+{
+	return __get_expression_value(expr, 1);
+}
diff --git a/expression.c b/expression.c
index 0108224..d36c3d2 100644
--- a/expression.c
+++ b/expression.c
@@ -117,6 +117,7 @@ static struct token *parse_type(struct token *token, struct expression **tree)
 {
 	struct symbol *sym;
 	*tree = alloc_expression(token->pos, EXPR_TYPE);
+	(*tree)->flags = Int_const_expr; /* sic */
 	token = typename(token, &sym);
 	if (sym->ident)
 		sparse_error(token->pos,
@@ -131,6 +132,7 @@ static struct token *builtin_types_compatible_p_expr(struct token *token,
 {
 	struct expression *expr = alloc_expression(
 		token->pos, EXPR_COMPARE);
+	expr->flags = Int_const_expr;
 	expr->op = SPECIAL_EQUAL;
 	token = token->next;
 	if (!match_op(token, '('))
@@ -184,6 +186,7 @@ static struct token *builtin_offsetof_expr(struct token *token,
 			return expect(token, ')', "at end of __builtin_offset");
 		case SPECIAL_DEREFERENCE:
 			e = alloc_expression(token->pos, EXPR_OFFSETOF);
+			e->flags = Int_const_expr;
 			e->op = '[';
 			*p = e;
 			p = &e->down;
@@ -191,6 +194,7 @@ static struct token *builtin_offsetof_expr(struct token *token,
 		case '.':
 			token = token->next;
 			e = alloc_expression(token->pos, EXPR_OFFSETOF);
+			e->flags = Int_const_expr;
 			e->op = '.';
 			if (token_type(token) != TOKEN_IDENT) {
 				sparse_error(token->pos, "Expected member name");
@@ -202,6 +206,7 @@ static struct token *builtin_offsetof_expr(struct token *token,
 		case '[':
 			token = token->next;
 			e = alloc_expression(token->pos, EXPR_OFFSETOF);
+			e->flags = Int_const_expr;
 			e->op = '[';
 			token = parse_expression(token, &e->index);
 			token = expect(token, ']',
@@ -353,6 +358,7 @@ got_it:
 			"likely to produce unsigned long (and a warning) here",
 			show_token(token));
         expr->type = EXPR_VALUE;
+	expr->flags = Int_const_expr;
         expr->ctype = ctype_integer(modifiers);
         expr->value = value;
 	return;
@@ -377,6 +383,7 @@ Float:
 	else
 		goto Enoint;
 
+	expr->flags = Float_literal;
 	expr->type = EXPR_FVALUE;
 	return;
 
@@ -391,6 +398,7 @@ struct token *primary_expression(struct token *token, struct expression **tree)
 	switch (token_type(token)) {
 	case TOKEN_CHAR:
 		expr = alloc_expression(token->pos, EXPR_VALUE);   
+		expr->flags = Int_const_expr;
 		expr->ctype = &int_ctype; 
 		expr->value = (unsigned char) token->character;
 		token = token->next;
@@ -398,12 +406,13 @@ struct token *primary_expression(struct token *token, struct expression **tree)
 
 	case TOKEN_NUMBER:
 		expr = alloc_expression(token->pos, EXPR_VALUE);
-		get_number_value(expr, token);
+		get_number_value(expr, token); /* will see if it's an integer */
 		token = token->next;
 		break;
 
 	case TOKEN_ZERO_IDENT: {
 		expr = alloc_expression(token->pos, EXPR_SYMBOL);
+		expr->flags = Int_const_expr;
 		expr->ctype = &int_ctype;
 		expr->symbol = &zero_int;
 		expr->symbol_name = token->ident;
@@ -431,6 +440,7 @@ struct token *primary_expression(struct token *token, struct expression **tree)
 			*expr = *sym->initializer;
 			/* we want the right position reported, thus the copy */
 			expr->pos = token->pos;
+			expr->flags = Int_const_expr;
 			token = next;
 			break;
 		}
@@ -465,10 +475,13 @@ struct token *primary_expression(struct token *token, struct expression **tree)
 			expr = alloc_expression(token->pos, EXPR_PREOP);
 			expr->op = '(';
 			token = parens_expression(token, &expr->unop, "in expression");
+			if (expr->unop)
+				expr->flags = expr->unop->flags;
 			break;
 		}
 		if (token->special == '[' && lookup_type(token->next)) {
 			expr = alloc_expression(token->pos, EXPR_TYPE);
+			expr->flags = Int_const_expr; /* sic */
 			token = typename(token->next, &expr->symbol);
 			token = expect(token, ']', "in type expression");
 			break;
@@ -583,6 +596,7 @@ static struct token *type_info_expression(struct token *token,
 	struct expression *expr = alloc_expression(token->pos, type);
 
 	*tree = expr;
+	expr->flags = Int_const_expr; /* XXX: VLA support will need that changed */
 	token = token->next;
 	if (!match_op(token, '(') || !lookup_type(token->next))
 		return unary_expression(token, &expr->cast_expression);
@@ -632,7 +646,7 @@ static struct token *unary_expression(struct token *token, struct expression **t
 	if (token_type(token) == TOKEN_SPECIAL) {
 		if (match_oplist(token->special,
 		    SPECIAL_INCREMENT, SPECIAL_DECREMENT,
-		    '&', '*', '+', '-', '~', '!', 0)) {
+		    '&', '*', 0)) {
 		    	struct expression *unop;
 			struct expression *unary;
 			struct token *next;
@@ -648,7 +662,24 @@ static struct token *unary_expression(struct token *token, struct expression **t
 			*tree = unary;
 			return next;
 		}
+		/* possibly constant ones */
+		if (match_oplist(token->special, '+', '-', '~', '!', 0)) {
+		    	struct expression *unop;
+			struct expression *unary;
+			struct token *next;
 
+			next = cast_expression(token->next, &unop);
+			if (!unop) {
+				sparse_error(token->pos, "Syntax error in unary expression");
+				return next;
+			}
+			unary = alloc_expression(token->pos, EXPR_PREOP);
+			unary->op = token->special;
+			unary->unop = unop;
+			unary->flags = unop->flags & Int_const_expr;
+			*tree = unary;
+			return next;
+		}
 		/* Gcc extension: &&label gives the address of a label */
 		if (match_op(token, SPECIAL_LOGICAL_AND) &&
 		    token_type(token->next) == TOKEN_IDENT) {
@@ -682,6 +713,7 @@ static struct token *cast_expression(struct token *token, struct expression **tr
 		struct token *next = token->next;
 		if (lookup_type(next)) {
 			struct expression *cast = alloc_expression(next->pos, EXPR_CAST);
+			struct expression *v;
 			struct symbol *sym;
 
 			token = typename(next, &sym);
@@ -692,7 +724,14 @@ static struct token *cast_expression(struct token *token, struct expression **tr
 				return postfix_expression(token, tree, cast);
 			}
 			*tree = cast;
-			token = cast_expression(token, &cast->cast_expression);
+			token = cast_expression(token, &v);
+			if (!v)
+				return token;
+			cast->cast_expression = v;
+			if (v->flags & Int_const_expr)
+				cast->flags = Int_const_expr;
+			else if (v->flags & Float_literal) /* and _not_ int */
+				cast->flags = Int_const_expr | Float_literal;
 			return token;
 		}
 	}
@@ -712,9 +751,9 @@ static struct token *cast_expression(struct token *token, struct expression **tr
  * than create a data structure for it.
  */
 
-#define LR_BINOP_EXPRESSION(token, tree, type, inner, compare)		\
+#define __LR_BINOP_EXPRESSION(__token, tree, type, inner, compare, is_const)	\
 	struct expression *left = NULL;					\
-	struct token * next = inner(token, &left);			\
+	struct token * next = inner(__token, &left);			\
 									\
 	if (left) {							\
 		while (token_type(next) == TOKEN_SPECIAL) {		\
@@ -729,6 +768,9 @@ static struct token *cast_expression(struct token *token, struct expression **tr
 				sparse_error(next->pos, "No right hand side of '%s'-expression", show_special(op));	\
 				break;					\
 			}						\
+			if (is_const)					\
+				top->flags = left->flags & right->flags \
+						& Int_const_expr;	\
 			top->op = op;					\
 			top->left = left;				\
 			top->right = right;				\
@@ -739,6 +781,12 @@ out:									\
 	*tree = left;							\
 	return next;							\
 
+#define LR_BINOP_EXPRESSION(token, tree, type, inner, compare) \
+	__LR_BINOP_EXPRESSION((token), (tree), (type), (inner), (compare), 1)
+
+#define LR_BINOP_EXPRESSION_NONCONST(token, tree, type, inner, compare) \
+	__LR_BINOP_EXPRESSION((token), (tree), (type), (inner), (compare), 0)
+
 
 static struct token *multiplicative_expression(struct token *token, struct expression **tree)
 {
@@ -832,6 +880,14 @@ struct token *conditional_expression(struct token *token, struct expression **tr
 		token = parse_expression(token->next, &expr->cond_true);
 		token = expect(token, ':', "in conditional expression");
 		token = conditional_expression(token, &expr->cond_false);
+		if (expr->left && expr->cond_true) {
+			int is_const = expr->left->flags &
+					expr->cond_false->flags &
+					Int_const_expr;
+			if (expr->cond_true)
+				is_const &= expr->cond_true->flags;
+			expr->flags = is_const;
+		}
 	}
 	return token;
 }
@@ -862,7 +918,7 @@ struct token *assignment_expression(struct token *token, struct expression **tre
 
 static struct token *comma_expression(struct token *token, struct expression **tree)
 {
-	LR_BINOP_EXPRESSION(
+	LR_BINOP_EXPRESSION_NONCONST(
 		token, tree, EXPR_COMMA, assignment_expression,
 		(op == ',')
 	);
diff --git a/expression.h b/expression.h
index 19e0302..a913153 100644
--- a/expression.h
+++ b/expression.h
@@ -47,8 +47,14 @@ enum expression_type {
 	EXPR_OFFSETOF,
 };
 
+enum {
+	Int_const_expr = 1,
+	Float_literal = 2,
+}; /* for expr->flags */
+
 struct expression {
-	enum expression_type type;
+	enum expression_type type:8;
+	unsigned flags:8;
 	int op;
 	struct position pos;
 	struct symbol *ctype;
@@ -142,6 +148,7 @@ struct expression {
 
 /* Constant expression values */
 long long get_expression_value(struct expression *);
+long long const_expression_value(struct expression *);
 
 /* Expression parsing */
 struct token *parse_expression(struct token *token, struct expression **tree);
diff --git a/parse.c b/parse.c
index 4e8a18b..cb9f87a 100644
--- a/parse.c
+++ b/parse.c
@@ -802,7 +802,7 @@ static struct token *attribute_aligned(struct token *token, struct symbol *attr,
 	if (match_op(token, '(')) {
 		token = parens_expression(token, &expr, "in attribute");
 		if (expr)
-			alignment = get_expression_value(expr);
+			alignment = const_expression_value(expr);
 	}
 	ctype->alignment = alignment;
 	return token;
@@ -820,7 +820,7 @@ static struct token *attribute_address_space(struct token *token, struct symbol
 	token = expect(token, '(', "after address_space attribute");
 	token = conditional_expression(token, &expr);
 	if (expr)
-		ctype->as = get_expression_value(expr);
+		ctype->as = const_expression_value(expr);
 	token = expect(token, ')', "after address_space attribute");
 	return token;
 }
@@ -1258,7 +1258,7 @@ static struct token *handle_bitfield(struct token *token, struct symbol *decl)
 
 	bitfield = alloc_indirect_symbol(token->pos, ctype, SYM_BITFIELD);
 	token = conditional_expression(token->next, &expr);
-	width = get_expression_value(expr);
+	width = const_expression_value(expr);
 	bitfield->bit_size = width;
 
 	if (width < 0 || width > INT_MAX) {
@@ -1844,10 +1844,10 @@ static struct expression *index_expression(struct expression *from, struct expre
 	int idx_from, idx_to;
 	struct expression *expr = alloc_expression(from->pos, EXPR_INDEX);
 
-	idx_from = get_expression_value(from);
+	idx_from = const_expression_value(from);
 	idx_to = idx_from;
 	if (to) {
-		idx_to = get_expression_value(to);
+		idx_to = const_expression_value(to);
 		if (idx_to < idx_from || idx_from < 0)
 			warning(from->pos, "nonsense array initializer index range");
 	}
-- 
1.5.0-rc2.GIT

