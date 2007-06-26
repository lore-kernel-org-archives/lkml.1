Return-Path: <linux-kernel-owner+w=401wt.eu-S1758750AbXFZWKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750AbXFZWKy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 18:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756770AbXFZWKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 18:10:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57694 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbXFZWKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 18:10:44 -0400
Date: Tue, 26 Jun 2007 23:10:41 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Josh Triplett <josh@freedesktop.org>
Cc: Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070626221040.GI21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467F531A.3030702@freedesktop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 10:31:06PM -0700, Josh Triplett wrote:
> Al Viro wrote:
> > Joy.  OK, folks, disregard 16/16 in the current form; everything prior
> > to it stands on its own.
> 
> Acknowledged.  The rest of the patches look good to me, so I'll merge 1-15
> soon, and ignore 16.

OK, here's the replacement.  First the handling of __builtin_offsetof()
(below in this mail), then integer constant expressions (in followup).
They can be pulled from
git://git.kernel.org/pub/scm/linux/kernel/git/viro/sparse.git/ integer-constant

>From a194f3e092f7b1c31502564b3fd7fcfce0910aff Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 26 Jun 2007 16:06:32 -0400
Subject: [PATCH] implement __builtin_offsetof()

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 evaluate.c   |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 expand.c     |    1 +
 expression.c |   67 ++++++++++++++++++++++++++++++++++++++++++++++
 expression.h |   10 +++++++
 ident-list.h |    1 +
 inline.c     |   18 +++++++++++-
 lib.c        |    1 -
 show-parse.c |    1 +
 8 files changed, 181 insertions(+), 2 deletions(-)

diff --git a/evaluate.c b/evaluate.c
index 07ebf0c..c702ac4 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -2608,6 +2608,87 @@ static struct symbol *evaluate_call(struct expression *expr)
 	return expr->ctype;
 }
 
+static struct symbol *evaluate_offsetof(struct expression *expr)
+{
+	struct expression *e = expr->down;
+	struct symbol *ctype = expr->in;
+	int class;
+
+	if (expr->op == '.') {
+		struct symbol *field;
+		int offset = 0;
+		if (!ctype) {
+			expression_error(expr, "expected structure or union");
+			return NULL;
+		}
+		examine_symbol_type(ctype);
+		class = classify_type(ctype, &ctype);
+		if (class != TYPE_COMPOUND) {
+			expression_error(expr, "expected structure or union");
+			return NULL;
+		}
+
+		field = find_identifier(expr->ident, ctype->symbol_list, &offset);
+		if (!field) {
+			expression_error(expr, "unknown member");
+			return NULL;
+		}
+		ctype = field;
+		expr->type = EXPR_VALUE;
+		expr->value = offset;
+		expr->ctype = size_t_ctype;
+	} else {
+		if (!ctype) {
+			expression_error(expr, "expected structure or union");
+			return NULL;
+		}
+		examine_symbol_type(ctype);
+		class = classify_type(ctype, &ctype);
+		if (class != (TYPE_COMPOUND | TYPE_PTR)) {
+			expression_error(expr, "expected array");
+			return NULL;
+		}
+		ctype = ctype->ctype.base_type;
+		if (!expr->index) {
+			expr->type = EXPR_VALUE;
+			expr->value = 0;
+			expr->ctype = size_t_ctype;
+		} else {
+			struct expression *idx = expr->index, *m;
+			struct symbol *i_type = evaluate_expression(idx);
+			int i_class = classify_type(i_type, &i_type);
+			if (!is_int(i_class)) {
+				expression_error(expr, "non-integer index");
+				return NULL;
+			}
+			unrestrict(idx, i_class, &i_type);
+			idx = cast_to(idx, size_t_ctype);
+			m = alloc_const_expression(expr->pos,
+						   ctype->bit_size >> 3);
+			m->ctype = size_t_ctype;
+			expr->type = EXPR_BINOP;
+			expr->left = idx;
+			expr->right = m;
+			expr->op = '*';
+			expr->ctype = size_t_ctype;
+		}
+	}
+	if (e) {
+		struct expression *copy = __alloc_expression(0);
+		*copy = *expr;
+		if (e->type == EXPR_OFFSETOF)
+			e->in = ctype;
+		if (!evaluate_expression(e))
+			return NULL;
+		expr->type = EXPR_BINOP;
+		expr->op = '+';
+		expr->ctype = size_t_ctype;
+		expr->left = copy;
+		expr->right = e;
+	}
+	return size_t_ctype;
+}
+
 struct symbol *evaluate_expression(struct expression *expr)
 {
 	if (!expr)
@@ -2688,6 +2769,9 @@ struct symbol *evaluate_expression(struct expression *expr)
 		expr->ctype = &type_ctype;
 		return &type_ctype;
 
+	case EXPR_OFFSETOF:
+		return evaluate_offsetof(expr);
+
 	/* These can not exist as stand-alone expressions */
 	case EXPR_INITIALIZER:
 	case EXPR_IDENTIFIER:
diff --git a/expand.c b/expand.c
index a46f1c2..c6d188e 100644
--- a/expand.c
+++ b/expand.c
@@ -968,6 +968,7 @@ static int expand_expression(struct expression *expr)
 	case EXPR_SIZEOF:
 	case EXPR_PTRSIZEOF:
 	case EXPR_ALIGNOF:
+	case EXPR_OFFSETOF:
 		expression_error(expr, "internal front-end error: sizeof in expansion?");
 		return UNSAFE;
 	}
diff --git a/expression.c b/expression.c
index a40ab2b..0108224 100644
--- a/expression.c
+++ b/expression.c
@@ -152,6 +152,69 @@ static struct token *builtin_types_compatible_p_expr(struct token *token,
 	return token;
 }
 
+static struct token *builtin_offsetof_expr(struct token *token,
+					   struct expression **tree)
+{
+	struct expression *expr = NULL;
+	struct expression **p = &expr;
+	struct symbol *sym;
+	int op = '.';
+
+	token = token->next;
+	if (!match_op(token, '('))
+		return expect(token, '(', "after __builtin_offset");
+
+	token = token->next;
+	token = typename(token, &sym);
+	if (sym->ident)
+		sparse_error(token->pos,
+			     "type expression should not include identifier "
+			     "\"%s\"", sym->ident->name);
+
+	if (!match_op(token, ','))
+		return expect(token, ',', "in __builtin_offset");
+
+	while (1) {
+		struct expression *e;
+		switch (op) {
+		case ')':
+			expr->in = sym;
+			*tree = expr;
+		default:
+			return expect(token, ')', "at end of __builtin_offset");
+		case SPECIAL_DEREFERENCE:
+			e = alloc_expression(token->pos, EXPR_OFFSETOF);
+			e->op = '[';
+			*p = e;
+			p = &e->down;
+			/* fall through */
+		case '.':
+			token = token->next;
+			e = alloc_expression(token->pos, EXPR_OFFSETOF);
+			e->op = '.';
+			if (token_type(token) != TOKEN_IDENT) {
+				sparse_error(token->pos, "Expected member name");
+				return token;
+			}
+			e->ident = token->ident;
+			token = token->next;
+			break;
+		case '[':
+			token = token->next;
+			e = alloc_expression(token->pos, EXPR_OFFSETOF);
+			e->op = '[';
+			token = parse_expression(token, &e->index);
+			token = expect(token, ']',
+					"at end of array dereference");
+			if (!e->index)
+				return token;
+		}
+		*p = e;
+		p = &e->down;
+		op = token_type(token) == TOKEN_SPECIAL ? token->special : 0;
+	}
+}
+
 static struct token *string_expression(struct token *token, struct expression *expr)
 {
 	struct string *string = token->string;
@@ -359,6 +422,10 @@ struct token *primary_expression(struct token *token, struct expression **tree)
 				token = builtin_types_compatible_p_expr(token, &expr);
 				break;
 			}
+			if (token->ident == &__builtin_offsetof_ident) {
+				token = builtin_offsetof_expr(token, &expr);
+				break;
+			}
 		} else if (sym->enum_member) {
 			expr = alloc_expression(token->pos, EXPR_VALUE);
 			*expr = *sym->initializer;
diff --git a/expression.h b/expression.h
index 1bf02c4..19e0302 100644
--- a/expression.h
+++ b/expression.h
@@ -44,6 +44,7 @@ enum expression_type {
 	EXPR_POS,		// position in initializer
 	EXPR_FVALUE,
 	EXPR_SLICE,
+	EXPR_OFFSETOF,
 };
 
 struct expression {
@@ -127,6 +128,15 @@ struct expression {
 			unsigned int init_offset, init_nr;
 			struct expression *init_expr;
 		};
+		// EXPR_OFFSETOF
+		struct {
+			struct symbol *in;
+			struct expression *down;
+			union {
+				struct ident *ident;
+				struct expression *index;
+			};
+		};
 	};
 };
 
diff --git a/ident-list.h b/ident-list.h
index 0f654bf..b183eac 100644
--- a/ident-list.h
+++ b/ident-list.h
@@ -29,6 +29,7 @@ IDENT(asm); IDENT_RESERVED(__asm); IDENT_RESERVED(__asm__);
 IDENT(alignof); IDENT_RESERVED(__alignof); IDENT_RESERVED(__alignof__); 
 IDENT_RESERVED(__sizeof_ptr__);
 IDENT_RESERVED(__builtin_types_compatible_p);
+IDENT_RESERVED(__builtin_offsetof);
 
 /* Attribute names */
 IDENT(packed); IDENT(__packed__);
diff --git a/inline.c b/inline.c
index f80403c..061261a 100644
--- a/inline.c
+++ b/inline.c
@@ -237,7 +237,23 @@ static struct expression * copy_expression(struct expression *expr)
 		expr->init_expr = val;
 		break;
 	}
-
+	case EXPR_OFFSETOF: {
+		struct expression *val = copy_expression(expr->down);
+		if (expr->op == '.') {
+			if (expr->down != val) {
+				expr = dup_expression(expr);
+				expr->down = val;
+			}
+		} else {
+			struct expression *idx = copy_expression(expr->index);
+			if (expr->down != val || expr->index != idx) {
+				expr = dup_expression(expr);
+				expr->down = val;
+				expr->index = idx;
+			}
+		}
+		break;
+	}
 	default:
 		warning(expr->pos, "trying to copy expression type %d", expr->type);
 	}
diff --git a/lib.c b/lib.c
index 7f6334c..7fea474 100644
--- a/lib.c
+++ b/lib.c
@@ -609,7 +609,6 @@ void create_builtin_stream(void)
 	add_pre_buffer("#define __builtin_va_arg_incr(x) ((x) + 1)\n");
 	add_pre_buffer("#define __builtin_va_copy(dest, src) ({ dest = src; (void)0; })\n");
 	add_pre_buffer("#define __builtin_va_end(arg)\n");
-	add_pre_buffer("#define __builtin_offsetof(type, name) ((__SIZE_TYPE__)&((type *)(0ul))->name)\n");
 
 	/* FIXME! We need to do these as special magic macros at expansion time! */
 	add_pre_buffer("#define __BASE_FILE__ \"base_file.c\"\n");
diff --git a/show-parse.c b/show-parse.c
index 0bef01c..07ee763 100644
--- a/show-parse.c
+++ b/show-parse.c
@@ -1049,6 +1049,7 @@ int show_expression(struct expression *expr)
 	case EXPR_SIZEOF:
 	case EXPR_PTRSIZEOF:
 	case EXPR_ALIGNOF:
+	case EXPR_OFFSETOF:
 		warning(expr->pos, "invalid expression after evaluation");
 		return 0;
 	case EXPR_CAST:
-- 
1.5.0-rc2.GIT

