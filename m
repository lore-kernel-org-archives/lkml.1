Return-Path: <linux-kernel-owner+w=401wt.eu-S1754905AbZDYCHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905AbZDYCHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 22:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZDYCGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 22:06:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50937 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638AbZDYCGv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 22:06:51 -0400
Message-ID: <49F27032.7050703@garzik.org>
Date: Fri, 24 Apr 2009 22:06:42 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-sparse@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, Al Viro <viro@ZenIV.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] sparse LLVM backend (was Re: [rfc] built-in native compiler
 for Linux?)
References: <49F09895.8000107@zytor.com> <20090423172507.GS13896@one.firstfloor.org> <alpine.LFD.2.00.0904231028370.3101@localhost.localdomain> <20090423183052.GS8633@ZenIV.linux.org.uk> <20090423190059.GA19772@elte.hu> <20090423190830.GU8633@ZenIV.linux.org.uk> <20090423191429.GB19772@elte.hu> <20090423192416.GX8633@ZenIV.linux.org.uk> <20090423205359.GA1102@elte.hu> <20090423231133.GZ8633@ZenIV.linux.org.uk> <20090424090919.GB6044@elte.hu>
In-Reply-To: <20090424090919.GB6044@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050606020802010008000702"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050606020802010008000702
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


(resent -- the mail monster apparently ate the first one)

Just to make this crazy thread even crazier, I have successfully gotten 
sparse to create a valid x86-64 object file from C source code (...which 
I then executed).

The attached patch adds a code generator backend to sparse, that 
generates LLVM bitcode.  This bitcode can then be converted to ELF .o 
files using standard tools -- see instructions in the header of s2l.c.

Do I expect this to be used in the kernel?  Not really.  I'm just doing 
this for fun, to add a compiler backend to sparse.  It was pretty easy 
to get integer and logical operations going.

The work is based on compile-i386; as it turns out, LLVM's bitcode can 
be made type-aware, so I wanted to see how things would turn out 
generating code at a higher level.  Given the higher-level constructs, I 
didn't feel the need to bother with linearized form.

Caveats...

- don't stray too far from simple, integer types
- bitfields caused explosions, but you knew that anyway

Cheers all,

     Jeff


--------------050606020802010008000702
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"


 .gitignore |    2 
 Makefile   |    3 
 s2l-gen.c  | 2101 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 s2l.c      |   77 ++
 4 files changed, 2182 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index a915ef3..eee93ec 100644
--- a/.gitignore
+++ b/.gitignore
@@ -2,6 +2,7 @@
 *.o
 *.a
 *.so
+*.o.d
 
 # generated
 pre-process.h
@@ -20,6 +21,7 @@ example
 test-unssa
 ctags
 c2xml
+s2l
 
 # tags
 tags
diff --git a/Makefile b/Makefile
index 15daba5..f993cf8 100644
--- a/Makefile
+++ b/Makefile
@@ -35,7 +35,7 @@ INCLUDEDIR=$(PREFIX)/include
 PKGCONFIGDIR=$(LIBDIR)/pkgconfig
 
 PROGRAMS=test-lexing test-parsing obfuscate compile graph sparse \
-	 test-linearize example test-unssa test-dissect ctags
+	 test-linearize example test-unssa test-dissect ctags s2l
 INST_PROGRAMS=sparse cgcc
 INST_MAN1=sparse.1 cgcc.1
 
@@ -108,6 +108,7 @@ sparse.pc: sparse.pc.in
 
 
 compile_EXTRA_DEPS = compile-i386.o
+s2l_EXTRA_DEPS = s2l-gen.o
 
 PROG_LINK_CMD = $(QUIET_LINK)$(CC) $(LDFLAGS) -o $@ $^ $($@_EXTRA_OBJS) 
 
diff --git a/s2l-gen.c b/s2l-gen.c
new file mode 100644
index 0000000..029d56b
--- /dev/null
+++ b/s2l-gen.c
@@ -0,0 +1,2101 @@
+
+/*
+ * sparse/s2l-gen.c
+ *
+ * Copyright (C) 2003 Transmeta Corp.
+ *               2003 Linus Torvalds
+ * Copyright 2003 Jeff Garzik
+ * Copyright 2009 Red Hat, Inc.
+ *
+ * Licensed under the Open Software License version 1.1
+ *
+ *
+ * A cheesy LLVM backend for sparse.  Outputs LLVM ASCII bitcode,
+ * given a C source code input.
+ *
+ *
+ * TODO list:
+ * 1) fill in TODO list
+ * 2) ?
+ * 3) Profit!
+ *
+ */
+
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <ctype.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <assert.h>
+
+#include "lib.h"
+#include "allocate.h"
+#include "token.h"
+#include "parse.h"
+#include "symbol.h"
+#include "scope.h"
+#include "expression.h"
+#include "target.h"
+#include "compile.h"
+#include "bitmap.h"
+
+struct textbuf {
+	unsigned int	len;	/* does NOT include terminating null */
+	char		*text;
+	struct textbuf	*next;
+	struct textbuf	*prev;
+};
+
+struct loop_stack {
+	int		continue_lbl;
+	int		loop_bottom_lbl;
+	struct loop_stack *next;
+};
+
+struct atom;
+struct storage;
+DECLARE_PTR_LIST(str_list, struct atom);
+DECLARE_PTR_LIST(atom_list, struct atom);
+DECLARE_PTR_LIST(storage_list, struct storage);
+
+struct function {
+	int stack_size;
+	int pseudo_nr;
+	struct storage_list *pseudo_list;
+	struct atom_list *atom_list;
+	struct str_list *str_list;
+	struct loop_stack *loop_stack;
+	struct symbol **argv;
+	unsigned int argc;
+	int ret_target;
+};
+
+enum storage_type {
+	STOR_PSEUDO,	/* variable stored on the stack */
+	STOR_ARG,	/* function argument */
+	STOR_SYM,	/* a symbol we can directly ref in the asm */
+	STOR_VALUE,	/* integer constant */
+	STOR_LABEL,	/* label / jump target */
+	STOR_LABELSYM,	/* label generated from symbol's pointer value */
+};
+
+struct storage {
+	enum storage_type type;
+	unsigned long flags;
+
+	/* STOR_REG */
+	struct symbol *ctype;
+
+	union {
+		/* STOR_PSEUDO */
+		struct {
+			int pseudo;
+			int offset;
+			int size;
+		};
+		/* STOR_ARG */
+		struct {
+			int idx;
+		};
+		/* STOR_SYM */
+		struct {
+			struct symbol *sym;
+		};
+		/* STOR_VALUE */
+		struct {
+			long long value;
+		};
+		/* STOR_LABEL */
+		struct {
+			int label;
+		};
+		/* STOR_LABELSYM */
+		struct {
+			struct symbol *labelsym;
+		};
+	};
+};
+
+enum {
+	STOR_LABEL_VAL	= (1 << 0),
+	STOR_WANTS_FREE	= (1 << 1),
+};
+
+struct symbol_private {
+	struct storage *addr;
+};
+
+enum atom_type {
+	ATOM_TEXT,
+	ATOM_CSTR,
+};
+
+struct atom {
+	enum atom_type type;
+	union {
+		/* stuff for text */
+		struct {
+			char *text;
+			unsigned int text_len;  /* w/o terminating null */
+		};
+
+		/* stuff for C strings */
+		struct {
+			struct string *string;
+			int label;
+		};
+	};
+};
+
+
+static struct function *current_func = NULL;
+static struct textbuf *unit_post_text = NULL;
+static const char *current_section;
+
+static void emit_comment(const char * fmt, ...) FORMAT_ATTR(1);
+static void emit_move(struct storage *src, struct storage *dest,
+		      struct symbol *ctype, const char *comment);
+static int type_is_signed(struct symbol *sym);
+static struct storage *s2l_gen_address_gen(struct expression *expr);
+static struct storage *s2l_gen_symbol_expr(struct symbol *sym);
+static void s2l_gen_symbol(struct symbol *sym);
+static struct storage *s2l_gen_statement(struct statement *stmt);
+static struct storage *s2l_gen_expression(struct expression *expr);
+
+static void stor_sym_init(struct symbol *sym)
+{
+	struct storage *stor;
+	struct symbol_private *priv;
+
+	priv = calloc(1, sizeof(*priv) + sizeof(*stor));
+	if (!priv)
+		die("OOM in stor_sym_init");
+
+	stor = (struct storage *) (priv + 1);
+
+	priv->addr = stor;
+	stor->type = STOR_SYM;
+	stor->sym = sym;
+}
+
+static const char *stor_op_name(struct storage *s)
+{
+	static char name[32];
+
+	switch (s->type) {
+	case STOR_PSEUDO:
+		sprintf(name, "%%tmp%u", s->pseudo);
+		break;
+	case STOR_ARG:
+		sprintf(name, "%%arg%u", s->idx);
+		break;
+	case STOR_SYM:
+		strcpy(name, show_ident(s->sym->ident));
+		break;
+	case STOR_VALUE:
+		sprintf(name, "%Ld", s->value);
+		break;
+	case STOR_LABEL:
+		sprintf(name, "@L%d", s->label);
+		break;
+	case STOR_LABELSYM:
+		sprintf(name, "%%LS%p", s->labelsym);
+		break;
+	}
+
+	return name;
+}
+
+static struct atom *new_atom(enum atom_type type)
+{
+	struct atom *atom;
+
+	atom = calloc(1, sizeof(*atom));	/* TODO: chunked alloc */
+	if (!atom)
+		die("nuclear OOM");
+
+	atom->type = type;
+
+	return atom;
+}
+
+static inline void push_cstring(struct function *f, struct string *str,
+				int label)
+{
+	struct atom *atom;
+
+	atom = new_atom(ATOM_CSTR);
+	atom->string = str;
+	atom->label = label;
+
+	add_ptr_list(&f->str_list, atom);	/* note: _not_ atom_list */
+}
+
+static inline void push_atom(struct function *f, struct atom *atom)
+{
+	add_ptr_list(&f->atom_list, atom);
+}
+
+static void push_text_atom(struct function *f, const char *text)
+{
+	struct atom *atom = new_atom(ATOM_TEXT);
+
+	atom->text = strdup(text);
+	atom->text_len = strlen(text);
+
+	push_atom(f, atom);
+}
+
+static struct storage *new_storage(enum storage_type type)
+{
+	struct storage *stor;
+
+	stor = calloc(1, sizeof(*stor));
+	if (!stor)
+		die("OOM in new_storage");
+
+	stor->type = type;
+
+	return stor;
+}
+
+static struct storage *stack_alloc(int n_bytes)
+{
+	struct function *f = current_func;
+	struct storage *stor;
+
+	assert(f != NULL);
+
+	stor = new_storage(STOR_PSEUDO);
+	stor->type = STOR_PSEUDO;
+	stor->pseudo = f->pseudo_nr;
+	stor->offset = f->stack_size; /* FIXME: stack req. natural align */
+	stor->size = n_bytes;
+	f->stack_size += n_bytes;
+	f->pseudo_nr++;
+
+	add_ptr_list(&f->pseudo_list, stor);
+
+	return stor;
+}
+
+static struct storage *new_labelsym(struct symbol *sym)
+{
+	struct storage *stor;
+
+	stor = new_storage(STOR_LABELSYM);
+
+	if (stor) {
+		stor->flags |= STOR_WANTS_FREE;
+		stor->labelsym = sym;
+	}
+
+	return stor;
+}
+
+static int new_label(void)
+{
+	static int label = 0;
+	return ++label;
+}
+
+static void textbuf_push(struct textbuf **buf_p, const char *text)
+{
+	struct textbuf *tmp, *list = *buf_p;
+	unsigned int text_len = strlen(text);
+	unsigned int alloc_len = text_len + 1 + sizeof(*list);
+
+	tmp = calloc(1, alloc_len);
+	if (!tmp)
+		die("OOM on textbuf alloc");
+
+	tmp->text = ((void *) tmp) + sizeof(*tmp);
+	memcpy(tmp->text, text, text_len + 1);
+	tmp->len = text_len;
+
+	/* add to end of list */
+	if (!list) {
+		list = tmp;
+		tmp->prev = tmp;
+	} else {
+		tmp->prev = list->prev;
+		tmp->prev->next = tmp;
+		list->prev = tmp;
+	}
+	tmp->next = list;
+
+	*buf_p = list;
+}
+
+#if 0
+static void textbuf_emit(struct textbuf **buf_p)
+{
+	struct textbuf *tmp, *list = *buf_p;
+
+	while (list) {
+		tmp = list;
+		if (tmp->next == tmp)
+			list = NULL;
+		else {
+			tmp->prev->next = tmp->next;
+			tmp->next->prev = tmp->prev;
+			list = tmp->next;
+		}
+
+		fputs(tmp->text, stdout);
+
+		free(tmp);
+	}
+
+	*buf_p = list;
+}
+#endif
+
+static void emit_comment(const char *fmt, ...)
+{
+	struct function *f = current_func;
+	static char tmpbuf[100] = "\t\t\t\t\t; ";
+	va_list args;
+	int i;
+
+	va_start(args, fmt);
+	i = vsnprintf(tmpbuf+7, sizeof(tmpbuf)-4, fmt, args);
+	va_end(args);
+	tmpbuf[i+7] = '\n';
+	tmpbuf[i+8] = '\0';
+	push_text_atom(f, tmpbuf);
+}
+
+static void emit_label (int label, const char *comment)
+{
+	struct function *f = current_func;
+	char s[64];
+
+	if (!comment)
+		sprintf(s, ".L%d:\n", label);
+	else
+		sprintf(s, ".L%d:\t\t\t\t\t; %s\n", label, comment);
+
+	push_text_atom(f, s);
+}
+
+static void emit_labelsym (struct symbol *sym, const char *comment)
+{
+	struct function *f = current_func;
+	char s[64];
+
+	if (!comment)
+		sprintf(s, ".LS%p:\n", sym);
+	else
+		sprintf(s, ".LS%p:\t\t\t\t; %s\n", sym, comment);
+
+	push_text_atom(f, s);
+}
+
+void emit_unit_begin(const char *basename)
+{
+}
+
+void emit_unit_end(void)
+{
+}
+
+/* conditionally switch sections */
+static void emit_section(const char *s)
+{
+	if (s == current_section)
+		return;
+	if (current_section && (!strcmp(s, current_section)))
+		return;
+
+#if 0
+	printf("\t%s\n", s);
+#endif
+	current_section = s;
+}
+
+static void emit_atom_list(struct function *f)
+{
+	struct atom *atom;
+
+	FOR_EACH_PTR(f->atom_list, atom) {
+		switch (atom->type) {
+		case ATOM_TEXT: {
+			ssize_t rc = write(STDOUT_FILENO, atom->text,
+					   atom->text_len);
+			(void) rc;	/* FIXME */
+			break;
+		}
+		case ATOM_CSTR:
+			assert(0);
+			break;
+		}
+	} END_FOR_EACH_PTR(atom);
+}
+
+static void emit_string_list(struct function *f)
+{
+	struct atom *atom;
+	size_t len;
+
+	emit_section(".section\t.rodata");
+
+	FOR_EACH_PTR(f->str_list, atom) {
+		/* FIXME: escape " in string */
+		/* FIXME 2: add trailing nul!!! */
+		len = strlen(show_string(atom->string)),
+		printf("@.L%d = internal constant [%lu x i8] c%s\n",
+		       atom->label,
+		       (unsigned long) len,
+		       show_string(atom->string));
+
+		free(atom);
+	} END_FOR_EACH_PTR(atom);
+
+	printf("\n");
+}
+
+static void func_cleanup(struct function *f)
+{
+	struct storage *stor;
+	struct atom *atom;
+
+	FOR_EACH_PTR(f->pseudo_list, stor) {
+		free(stor);
+	} END_FOR_EACH_PTR(stor);
+
+	FOR_EACH_PTR(f->atom_list, atom) {
+		if ((atom->type == ATOM_TEXT) && (atom->text))
+			free(atom->text);
+		free(atom);
+	} END_FOR_EACH_PTR(atom);
+
+	free_ptr_list(&f->pseudo_list);
+	free(f);
+}
+
+static const char *s2l_show_type(struct symbol *base_type)
+{
+	static char buf[256];
+
+	if (base_type == &void_ctype)
+		return "void";
+
+	sprintf(buf, "i%d", base_type->bit_size);
+	return buf;
+}
+
+/* function prologue */
+static void emit_func_pre(struct symbol *sym)
+{
+	struct function *f;
+	struct symbol *arg, *arg_bt;
+	unsigned int i, argc = 0, alloc_len;
+	unsigned char *mem;
+	struct symbol_private *privbase;
+	struct storage *storage_base;
+	struct symbol *base_type = sym->ctype.base_type;
+	struct symbol *ret_type = sym->ctype.base_type->ctype.base_type;
+	int first_arg = 1;
+	char defstr[512], stmp[128];
+
+	sprintf(defstr, "define %s%s @%s (",
+	       (sym->ctype.modifiers & MOD_STATIC) ? "internal " : "",
+	       s2l_show_type(ret_type),
+	       show_ident(sym->ident));
+
+	FOR_EACH_PTR(base_type->arguments, arg) {
+		const char *s;
+
+		arg_bt = arg->ctype.base_type;
+
+		s = s2l_show_type(arg_bt);
+
+		sprintf(stmp, "%s%s %%arg%u",
+		       first_arg ? "" : ", ",
+		       s, argc++);
+
+		strcat(defstr, stmp);
+
+		first_arg = 0;
+	} END_FOR_EACH_PTR(arg);
+
+	strcat(defstr, ") nounwind {\nentry:\n");
+
+	alloc_len =
+		sizeof(*f) +
+		(argc * sizeof(struct symbol *)) +
+		(argc * sizeof(struct symbol_private)) +
+		(argc * sizeof(struct storage));
+	mem = calloc(1, alloc_len);
+	if (!mem)
+		die("OOM on func info");
+
+	f		=  (struct function *) mem;
+	mem		+= sizeof(*f);
+	f->argv		=  (struct symbol **) mem;
+	mem		+= (argc * sizeof(struct symbol *));
+	privbase	=  (struct symbol_private *) mem;
+	mem		+= (argc * sizeof(struct symbol_private));
+	storage_base	=  (struct storage *) mem;
+
+	f->argc = argc;
+	f->ret_target = new_label();
+
+	i = 0;
+	FOR_EACH_PTR(base_type->arguments, arg) {
+		f->argv[i] = arg;
+		arg->aux = &privbase[i];
+		storage_base[i].type = STOR_ARG;
+		storage_base[i].idx = i;
+		storage_base[i].size = arg->ctype.base_type->bit_size / 8;
+		privbase[i].addr = &storage_base[i];
+		i++;
+	} END_FOR_EACH_PTR(arg);
+
+	assert(current_func == NULL);
+	current_func = f;
+
+	push_text_atom(current_func, defstr);
+
+}
+
+/* function epilogue */
+static void emit_func_post(struct symbol *sym)
+{
+	struct function *f = current_func;
+
+	if (f->str_list)
+		emit_string_list(f);
+
+	/* function epilogue */
+
+	/* output everything to stdout */
+	fflush(stdout);		/* paranoia; needed? */
+	emit_atom_list(f);
+
+	/* function footer */
+	printf("}\n\n");
+
+	/* FIXME: issue 'ret' if not already done */
+
+	func_cleanup(f);
+	current_func = NULL;
+}
+
+/* emit object (a.k.a. variable, a.k.a. data) prologue */
+static void emit_object_pre(const char *name, unsigned long modifiers,
+			    unsigned long alignment, unsigned int byte_size)
+{
+	if ((modifiers & MOD_STATIC) == 0)
+		printf(".globl %s\n", name);
+	emit_section(".data");
+	if (alignment)
+		printf("\t.align %lu\n", alignment);
+	printf("\t.type\t%s, @object\n", name);
+	printf("\t.size\t%s, %d\n", name, byte_size);
+	printf("%s:\n", name);
+}
+
+/* emit value (only) for an initializer scalar */
+static void emit_scalar(struct expression *expr, unsigned int bit_size)
+{
+	const char *type;
+	long long ll;
+
+	assert(expr->type == EXPR_VALUE);
+
+	if (expr->value == 0ULL) {
+		printf("\t.zero\t%d\n", bit_size / 8);
+		return;
+	}
+
+	ll = (long long) expr->value;
+
+	switch (bit_size) {
+	case 8:		type = "byte";	ll = (char) ll; break;
+	case 16:	type = "value";	ll = (short) ll; break;
+	case 32:	type = "long";	ll = (int) ll; break;
+	case 64:	type = "quad";	break;
+	default:	type = NULL;	break;
+	}
+
+	assert(type != NULL);
+
+	printf("\t.%s\t%Ld\n", type, ll);
+}
+
+static void emit_global_noinit(const char *name, unsigned long modifiers,
+			       unsigned long alignment, unsigned int byte_size)
+{
+	char s[64];
+
+	if (modifiers & MOD_STATIC) {
+		sprintf(s, "\t.local\t%s\n", name);
+		textbuf_push(&unit_post_text, s);
+	}
+	if (alignment)
+		sprintf(s, "\t.comm\t%s,%d,%lu\n", name, byte_size, alignment);
+	else
+		sprintf(s, "\t.comm\t%s,%d\n", name, byte_size);
+	textbuf_push(&unit_post_text, s);
+}
+
+static int ea_current, ea_last;
+
+static void emit_initializer(struct symbol *sym,
+			     struct expression *expr)
+{
+	int distance = ea_current - ea_last - 1;
+
+	if (distance > 0)
+		printf("\t.zero\t%d\n", (sym->bit_size / 8) * distance);
+
+	if (expr->type == EXPR_VALUE) {
+		struct symbol *base_type = sym->ctype.base_type;
+		assert(base_type != NULL);
+
+		emit_scalar(expr, sym->bit_size / get_expression_value(base_type->array_size));
+		return;
+	}
+	if (expr->type != EXPR_INITIALIZER)
+		return;
+
+	assert(0); /* FIXME */
+}
+
+static int sort_array_cmp(const struct expression *a,
+			  const struct expression *b)
+{
+	int a_ofs = 0, b_ofs = 0;
+
+	if (a->type == EXPR_POS)
+		a_ofs = (int) a->init_offset;
+	if (b->type == EXPR_POS)
+		b_ofs = (int) b->init_offset;
+
+	return a_ofs - b_ofs;
+}
+
+/* move to front-end? */
+static void sort_array(struct expression *expr)
+{
+	struct expression *entry, **list;
+	unsigned int elem, sorted, i;
+
+	elem = 0;
+	FOR_EACH_PTR(expr->expr_list, entry) {
+		elem++;
+	} END_FOR_EACH_PTR(entry);
+
+	if (!elem)
+		return;
+
+	list = malloc(sizeof(entry) * elem);
+	if (!list)
+		die("OOM in sort_array");
+
+	/* this code is no doubt evil and ignores EXPR_INDEX possibly
+	 * to its detriment and other nasty things.  improvements
+	 * welcome.
+	 */
+	i = 0;
+	sorted = 0;
+	FOR_EACH_PTR(expr->expr_list, entry) {
+		if ((entry->type == EXPR_POS) || (entry->type == EXPR_VALUE)) {
+			/* add entry to list[], in sorted order */
+			if (sorted == 0) {
+				list[0] = entry;
+				sorted = 1;
+			} else {
+				for (i = 0; i < sorted; i++)
+					if (sort_array_cmp(entry, list[i]) <= 0)
+						break;
+
+				/* If inserting into the middle of list[]
+				 * instead of appending, we memmove.
+				 * This is ugly, but thankfully
+				 * uncommon.  Input data with tons of
+				 * entries very rarely have explicit
+				 * offsets.  convert to qsort eventually...
+				 */
+				if (i != sorted)
+					memmove(&list[i + 1], &list[i],
+						(sorted - i) * sizeof(entry));
+				list[i] = entry;
+				sorted++;
+			}
+		}
+	} END_FOR_EACH_PTR(entry);
+
+	i = 0;
+	FOR_EACH_PTR(expr->expr_list, entry) {
+		if ((entry->type == EXPR_POS) || (entry->type == EXPR_VALUE))
+			*THIS_ADDRESS(entry) = list[i++];
+	} END_FOR_EACH_PTR(entry);
+
+}
+
+static void emit_array(struct symbol *sym)
+{
+	struct symbol *base_type = sym->ctype.base_type;
+	struct expression *expr = sym->initializer;
+	struct expression *entry;
+
+	assert(base_type != NULL);
+
+	stor_sym_init(sym);
+
+	ea_last = -1;
+
+	emit_object_pre(show_ident(sym->ident), sym->ctype.modifiers,
+		        sym->ctype.alignment,
+			sym->bit_size / 8);
+
+	sort_array(expr);
+
+	FOR_EACH_PTR(expr->expr_list, entry) {
+		if (entry->type == EXPR_VALUE) {
+			ea_current = 0;
+			emit_initializer(sym, entry);
+			ea_last = ea_current;
+		} else if (entry->type == EXPR_POS) {
+			ea_current =
+			    entry->init_offset / (base_type->bit_size / 8);
+			emit_initializer(sym, entry->init_expr);
+			ea_last = ea_current;
+		}
+	} END_FOR_EACH_PTR(entry);
+}
+
+void emit_one_symbol(struct symbol *sym)
+{
+	s2l_gen_symbol(sym);
+}
+
+static void emit_copy(struct storage *src, struct storage *dest,
+		      struct symbol *ctype)
+{
+	struct storage *tmp;
+	unsigned int bit_size;
+
+	/* FIXME: Bitfield copy! */
+
+	bit_size = src->size * 8;
+	if (!bit_size)
+		bit_size = 32;
+	if ((src->type == STOR_ARG) && (bit_size < 32))
+		bit_size = 32;
+
+	tmp = stack_alloc(bit_size / 8);
+
+	emit_move(src, tmp, ctype, "begin copy ..");
+
+	bit_size = dest->size * 8;
+	if (!bit_size)
+		bit_size = 32;
+	if ((dest->type == STOR_ARG) && (bit_size < 32))
+		bit_size = 32;
+
+	emit_move(tmp, dest, ctype, ".... end copy");
+}
+
+static void emit_store(struct expression *dest_expr, struct storage *dest,
+		       struct storage *src, int bits)
+{
+	/* FIXME: Bitfield store! */
+	printf("\tst.%d\t\tv%d,[v%d]\n", bits, src->pseudo, dest->pseudo);
+}
+
+static void emit_scalar_noinit(struct symbol *sym)
+{
+	emit_global_noinit(show_ident(sym->ident),
+			   sym->ctype.modifiers, sym->ctype.alignment,
+			   sym->bit_size / 8);
+	stor_sym_init(sym);
+}
+
+static void emit_array_noinit(struct symbol *sym)
+{
+	emit_global_noinit(show_ident(sym->ident),
+			   sym->ctype.modifiers, sym->ctype.alignment,
+			   get_expression_value(sym->array_size) * (sym->bit_size / 8));
+	stor_sym_init(sym);
+}
+
+static void emit_move(struct storage *src, struct storage *dest,
+		      struct symbol *ctype, const char *comment)
+{
+	unsigned int bits;
+	unsigned int is_signed;
+	char insnstr[128];
+	char stor_src[16], stor_dest[16];
+
+	if (ctype) {
+		bits = ctype->bit_size;
+		is_signed = type_is_signed(ctype);
+	} else {
+		bits = 32;
+		is_signed = 0;
+	}
+
+	strcpy(stor_src, stor_op_name(src));
+	strcpy(stor_dest, stor_op_name(dest));
+
+	sprintf(insnstr, "\t%s = add i%d 0, %s\t; %s\n",
+		stor_dest,
+		bits,
+		stor_src,
+		comment);
+	push_text_atom(current_func, insnstr);
+}
+
+static struct storage *emit_compare(struct expression *expr)
+{
+	struct function *f = current_func;
+	struct storage *left = s2l_gen_expression(expr->left);
+	struct storage *right = s2l_gen_expression(expr->right);
+	struct storage *val;
+	const char *opname = NULL;
+	unsigned int right_bits = expr->right->ctype->bit_size;
+	char insnstr[128];
+	char stor_val[16], stor_left[16], stor_right[16];
+
+	switch(expr->op) {
+	case '<':
+		opname = "slt";
+		break;
+	case SPECIAL_UNSIGNED_LT:
+		opname = "ult";
+		break;
+	case '>':
+		opname = "sgt";
+		break;
+	case SPECIAL_UNSIGNED_GT:
+		opname = "ugt";
+		break;
+	case SPECIAL_LTE:
+		opname = "sle";
+		break;
+	case SPECIAL_UNSIGNED_LTE:
+		opname = "ule";
+		break;
+	case SPECIAL_GTE:
+		opname = "sge";
+		break;
+	case SPECIAL_UNSIGNED_GTE:
+		opname = "uge";
+		break;
+	case SPECIAL_EQUAL:
+		opname = "eq";
+		break;
+	case SPECIAL_NOTEQUAL:
+		opname = "ne";
+		break;
+	default:
+		assert(0);
+		break;
+	}
+
+	/* init to 0 */
+	val = stack_alloc(right_bits / 8);
+	val->flags = STOR_WANTS_FREE;
+
+	strcpy(stor_val, stor_op_name(val));
+	strcpy(stor_left, stor_op_name(left));
+	strcpy(stor_right, stor_op_name(right));
+
+	sprintf(insnstr, "\t%s = icmp %s i%d %s, %s\n",
+		stor_val,
+		opname,
+		right_bits,
+		stor_left,
+		stor_right);
+	push_text_atom(f, insnstr);
+
+	return val;
+}
+
+static struct storage *emit_value(struct expression *expr)
+{
+	struct storage *val;
+
+	val = new_storage(STOR_VALUE);
+	val->value = (long long) expr->value;
+
+	return val;	/* FIXME: memory leak */
+}
+
+static struct storage *emit_binop(struct expression *expr)
+{
+	struct function *f = current_func;
+	struct storage *left = s2l_gen_expression(expr->left);
+	struct storage *right = s2l_gen_expression(expr->right);
+	struct storage *new;
+	const char *opname = NULL;
+	char insnstr[128];
+	char stor_new[16], stor_left[16], stor_right[16];
+	int is_signed;
+
+	is_signed = type_is_signed(expr->ctype);
+
+	switch (expr->op) {
+	case '+':
+		opname = "add";
+		break;
+	case '-':
+		opname = "sub";
+		break;
+	case '&':
+		opname = "and";
+		break;
+	case '|':
+		opname = "or";
+		break;
+	case '^':
+		opname = "xor";
+		break;
+	case SPECIAL_LEFTSHIFT:
+		opname = "shl";
+		break;
+	case SPECIAL_RIGHTSHIFT:
+		if (is_signed)
+			opname = "lshr";
+		else
+			opname = "ashr";
+		break;
+	case '*':
+		opname = "mul";
+		break;
+	case '/':
+		if (is_signed)
+			opname = "sdiv";
+		else
+			opname = "udiv";
+		break;
+	case '%':
+		if (is_signed)
+			opname = "srem";
+		else
+			opname = "urem";
+		break;
+	default:
+		error_die(expr->pos, "unhandled binop '%s'\n", show_special(expr->op));
+		break;
+	}
+
+	new = stack_alloc(expr->ctype->bit_size / 8);
+
+	strcpy(stor_new, stor_op_name(new));
+	strcpy(stor_left, stor_op_name(left));
+	strcpy(stor_right, stor_op_name(right));
+
+	sprintf(insnstr, "\t%s = %s i%d %s, %s\n",
+		stor_new,
+		opname,
+		expr->ctype->bit_size,
+		stor_left,
+		stor_right);
+	push_text_atom(f, insnstr);
+
+	return new;
+}
+
+static void emit_conditional_test(struct storage *val,
+				  struct storage **t_out,
+				  struct storage **f_out)
+{
+	struct storage *tmp, *lbl_true, *lbl_false;
+	int target_true, target_false;
+	char insnstr[128];
+	char stor_val[16], stor_tmp[16];
+	char stor_true[16], stor_false[16];
+
+	emit_comment("begin if/conditional");
+
+	tmp = stack_alloc(val->size);
+
+	target_true = new_label();
+	lbl_true = new_storage(STOR_LABEL);
+	lbl_true->label = target_true;
+	lbl_true->flags = STOR_WANTS_FREE;
+
+	*t_out = lbl_true;
+
+	target_false = new_label();
+	lbl_false = new_storage(STOR_LABEL);
+	lbl_false->label = target_false;
+	lbl_false->flags = STOR_WANTS_FREE;
+
+	*f_out = lbl_false;
+
+	strcpy(stor_val, stor_op_name(val));
+	strcpy(stor_tmp, stor_op_name(tmp));
+	strcpy(stor_true, stor_op_name(lbl_true));
+	strcpy(stor_false, stor_op_name(lbl_false));
+
+	sprintf(insnstr, "\t%s = icmp eq i%d 0, %s\n",
+		stor_tmp,
+		val->size * 8,
+		stor_val);
+	push_text_atom(current_func, insnstr);
+
+	sprintf(insnstr, "\tbr i1 %s, label %s, label %s\n",
+		stor_tmp,
+		stor_true,
+		stor_false);
+	push_text_atom(current_func, insnstr);
+}
+
+static void emit_conditional_end(struct storage *l_false,
+				 struct storage *cond_end_st)
+{
+	char insnstr[128];
+
+	sprintf(insnstr, "\tbr label %s\n",
+		stor_op_name(cond_end_st));
+	push_text_atom(current_func, insnstr);
+
+	emit_label(l_false->label, "if false");
+}
+
+static void emit_if_conditional(struct statement *stmt)
+{
+	struct storage *val;
+	struct storage *l_true = NULL, *l_false = NULL;
+	struct storage *cond_end_st;
+	int cond_end;
+
+	cond_end = new_label();
+	cond_end_st = new_storage(STOR_LABEL);
+	cond_end_st->label = cond_end;
+	cond_end_st->flags = STOR_WANTS_FREE;
+
+	/* emit test portion of conditional */
+	val = s2l_gen_expression(stmt->if_conditional);
+	emit_conditional_test(val, &l_true, &l_false);
+
+	emit_label(l_true->label, "if true");
+
+	/* emit if-true statement */
+	s2l_gen_statement(stmt->if_true);
+
+	emit_conditional_end(l_false, cond_end_st);
+
+	/* emit if-false statement, if present */
+	s2l_gen_statement(stmt->if_false);
+
+	/* end of conditional; jump target for if-true branch */
+	emit_label(cond_end, "end if");
+}
+
+static struct storage *emit_inc_dec(struct expression *expr, int postop)
+{
+	struct storage *addr = s2l_gen_address_gen(expr->unop);
+	struct storage *retval;
+	char opname[16];
+	char insnstr[128];
+	char stor_addr[16], stor_retval[16];
+
+	strcpy(opname, expr->op == SPECIAL_INCREMENT ? "add" : "sub");
+
+	if (postop) {
+		struct storage *new = stack_alloc(4);
+
+		emit_copy(addr, new, expr->unop->ctype);
+
+		retval = new;
+	} else
+		retval = addr;
+
+	strcpy(stor_addr, stor_op_name(addr));
+	strcpy(stor_retval, stor_op_name(retval));
+
+	sprintf(insnstr, "\t%s = %s i%d %s, 1\n",
+		stor_retval,
+		opname,
+		expr->ctype->bit_size,
+		stor_addr);
+	push_text_atom(current_func, insnstr);
+
+	return retval;
+}
+
+static struct storage *emit_postop(struct expression *expr)
+{
+	return emit_inc_dec(expr, 1);
+}
+
+static struct storage *emit_return_stmt(struct statement *stmt)
+{
+	struct function *f = current_func;
+	struct expression *expr = stmt->ret_value;
+	struct storage *val = NULL;
+
+	if (expr && expr->ctype) {
+		char s[64];
+
+		val = s2l_gen_expression(expr);
+		assert(val != NULL);
+
+		sprintf(s, "\tret i%d %s\n",
+			val->size * 8,
+			stor_op_name(val));
+		push_text_atom(f, s);
+	} else
+		push_text_atom(f, "\tret void\n");
+
+	return val;
+}
+
+static struct storage *emit_conditional_expr(struct expression *expr)
+{
+	struct storage *cond, *true = NULL, *false = NULL;
+	struct storage *new = stack_alloc(expr->ctype->bit_size / 8);
+	struct storage *l_true = NULL, *l_false = NULL;
+	struct storage *cond_end_st;
+	int cond_end;
+
+	cond_end = new_label();
+	cond_end_st = new_storage(STOR_LABEL);
+	cond_end_st->label = cond_end;
+	cond_end_st->flags = STOR_WANTS_FREE;
+
+	/* evaluate conditional */
+	cond = s2l_gen_expression(expr->conditional);
+	emit_conditional_test(cond, &l_true, &l_false);
+
+	emit_label(l_true->label, "if true");
+
+	/* handle if-true part of the expression */
+	true = s2l_gen_expression(expr->cond_true);
+
+	emit_copy(true, new, expr->ctype);
+
+	emit_conditional_end(l_false, cond_end_st);
+
+	/* handle if-false part of the expression */
+	false = s2l_gen_expression(expr->cond_false);
+
+	emit_copy(false, new, expr->ctype);
+
+	/* end of conditional; jump target for if-true branch */
+	emit_label(cond_end, "end conditional");
+
+	return new;
+}
+
+static struct storage *emit_symbol_expr_init(struct symbol *sym)
+{
+	struct expression *expr = sym->initializer;
+	struct symbol_private *priv = sym->aux;
+
+	if (priv == NULL) {
+		priv = calloc(1, sizeof(*priv));
+		sym->aux = priv;
+
+		if (expr == NULL) {
+			struct storage *new = stack_alloc(4);
+			fprintf(stderr, "FIXME! no value for symbol %s.  creating pseudo %d (stack offset %d)\n",
+				show_ident(sym->ident),
+				new->pseudo, new->pseudo * 4);
+			priv->addr = new;
+		} else {
+			priv->addr = s2l_gen_expression(expr);
+		}
+	}
+
+	return priv->addr;
+}
+
+static struct storage *emit_string_expr(struct expression *expr)
+{
+	struct function *f = current_func;
+	int label = new_label();
+	struct storage *new;
+
+	push_cstring(f, expr->string, label);
+
+	new = new_storage(STOR_LABEL);
+	new->label = label;
+	new->flags = STOR_LABEL_VAL | STOR_WANTS_FREE;
+	return new;
+}
+
+static struct storage *emit_cast_expr(struct expression *expr)
+{
+	struct symbol *old_type, *new_type;
+	struct storage *op = s2l_gen_expression(expr->cast_expression);
+	int oldbits, newbits, old_is_signed;
+	struct storage *new;
+	char insnstr[128];
+	char stor_src[16], stor_dest[16];
+
+	old_type = expr->cast_expression->ctype;
+	old_is_signed = type_is_signed(expr->cast_expression->ctype);
+	new_type = expr->cast_type;
+
+	oldbits = old_type->bit_size;
+	newbits = new_type->bit_size;
+	if (oldbits >= newbits)
+		return op;
+
+	new = stack_alloc(newbits / 8);
+
+	strcpy(stor_src, stor_op_name(op));
+	strcpy(stor_dest, stor_op_name(new));
+
+	sprintf(insnstr, "\t%s = %cext i%d %s to i%d\n",
+		stor_dest,
+		old_is_signed ? 's' : 'z',
+		oldbits,
+		stor_src,
+		newbits);
+	push_text_atom(current_func, insnstr);
+
+	return new;
+}
+
+static struct storage *emit_regular_preop(struct expression *expr)
+{
+	struct storage *target = s2l_gen_expression(expr->unop);
+	struct storage *val;
+	int bit_size = expr->unop->ctype->bit_size;
+	struct storage *new;
+	char insnstr[128];
+	char stor_target[16];
+	int lbl_true, lbl_false, lbl_end;
+
+	new = stack_alloc(bit_size / 8);
+
+	strcpy(stor_target, stor_op_name(target));
+
+	switch (expr->op) {
+	case '!':
+		/* compare target with zero */
+		sprintf(insnstr, "\t%%tmp = icmp i%d eq 0, %s\n",
+			bit_size,
+			stor_op_name(target));
+		push_text_atom(current_func, insnstr);
+
+		lbl_true = new_label();
+		lbl_false = new_label();
+		lbl_end = new_label();
+
+		/* if true, goto lbl_true, else goto lbl_false */
+		sprintf(insnstr, "\tbr i1 %%tmp, label %%L%d, label %%L%d\n",
+			lbl_true, lbl_false);
+		push_text_atom(current_func, insnstr);
+
+		/* label lbl_true outputted */
+		emit_label(lbl_true, "preop '!': value is zero");
+
+		/* move constant 1 to result */
+		val = new_storage(STOR_VALUE);
+		val->flags = STOR_WANTS_FREE;
+		val->value = 1;
+
+		emit_move(val, new, expr->unop->ctype, NULL);
+
+		/* jump to end of comparison */
+		sprintf(insnstr, "\tbr label %%L%d\n", lbl_end);
+
+		/* label lbl_false outputted */
+		emit_label(lbl_false, "preop '!': value not zero");
+
+		/* move constant 0 to result */
+		val = new_storage(STOR_VALUE);
+		val->flags = STOR_WANTS_FREE;
+		val->value = 0;
+
+		emit_move(val, new, expr->unop->ctype, NULL);
+
+		/* emit end label */
+		emit_label(lbl_end, "end preop '!'");
+		break;
+
+	case '~':
+		sprintf(insnstr, "\t%s = xor i%d %s, -1\n",
+			stor_op_name(new),
+			bit_size,
+			stor_target);
+		push_text_atom(current_func, insnstr);
+		break;
+
+	case '-':
+		sprintf(insnstr, "\t%s = sub i%d 0, %s\n",
+			stor_op_name(new),
+			bit_size,
+			stor_target);
+		push_text_atom(current_func, insnstr);
+		break;
+	default:
+		assert(0);
+		break;
+	}
+
+	return new;
+}
+
+static void emit_case_statement(struct statement *stmt)
+{
+	emit_labelsym(stmt->case_label, NULL);
+	s2l_gen_statement(stmt->case_statement);
+}
+
+static void emit_switch_statement(struct statement *stmt)
+{
+	struct storage *val = s2l_gen_expression(stmt->switch_expression);
+	struct symbol *sym, *default_sym = NULL;
+	struct storage *labelsym;
+	char insnstr[128];
+	char stor_val[16], stor_lbl_def[16], stor_lbl_sym[16];
+
+	FOR_EACH_PTR(stmt->switch_case->symbol_list, sym) {
+		struct statement *case_stmt = sym->stmt;
+		struct expression *expr = case_stmt->case_expression;
+		if (!expr)
+			default_sym = sym;
+	} END_FOR_EACH_PTR(sym);
+
+	if (default_sym)
+		labelsym = new_labelsym(default_sym);
+	else {
+		labelsym = new_storage(STOR_LABEL);
+		labelsym->label = new_label();
+		labelsym->flags = STOR_WANTS_FREE;
+	}
+
+	strcpy(stor_val, stor_op_name(val));
+	strcpy(stor_lbl_def, stor_op_name(labelsym));
+
+	sprintf(insnstr, "\tswitch i%d %s, label %s [\n",
+		val->size * 8,
+		stor_val,
+		stor_lbl_def);
+	push_text_atom(current_func, insnstr);
+
+	FOR_EACH_PTR(stmt->switch_case->symbol_list, sym) {
+		struct statement *case_stmt = sym->stmt;
+		struct expression *expr = case_stmt->case_expression;
+		/* struct expression *to = case_stmt->case_to; FIXME! */
+
+		/* case NNN: */
+		if (expr) {
+			assert (expr->type == EXPR_VALUE);
+
+			labelsym = new_labelsym(sym);
+			strcpy(stor_lbl_sym, stor_op_name(labelsym));
+
+			sprintf(insnstr, "\t\t\t\ti%d %lld, label %s\n",
+				val->size * 8,
+				expr->value,
+				stor_lbl_sym);
+			push_text_atom(current_func, insnstr);
+		}
+	} END_FOR_EACH_PTR(sym);
+
+	strcpy(insnstr, "\t\t\t\t]\n");
+	push_text_atom(current_func, insnstr);
+
+	s2l_gen_statement(stmt->switch_statement);
+
+	if (stmt->switch_break->used)
+		emit_labelsym(stmt->switch_break, NULL);
+}
+
+static void s2l_gen_struct_member(struct symbol *sym)
+{
+	printf("\t%s:%d:%ld at offset %ld.%d", show_ident(sym->ident), sym->bit_size, sym->ctype.alignment, sym->offset, sym->bit_offset);
+	printf("\n");
+}
+
+static void s2l_gen_symbol(struct symbol *sym)
+{
+	struct symbol *type;
+
+	if (!sym)
+		return;
+
+	type = sym->ctype.base_type;
+	if (!type)
+		return;
+
+	/*
+	 * Show actual implementation information
+	 */
+	switch (type->type) {
+
+	case SYM_ARRAY:
+		if (sym->initializer)
+			emit_array(sym);
+		else
+			emit_array_noinit(sym);
+		break;
+
+	case SYM_BASETYPE:
+		if (sym->initializer) {
+			emit_object_pre(show_ident(sym->ident),
+					sym->ctype.modifiers,
+				        sym->ctype.alignment,
+					sym->bit_size / 8);
+			emit_scalar(sym->initializer, sym->bit_size);
+			stor_sym_init(sym);
+		} else
+			emit_scalar_noinit(sym);
+		break;
+
+	case SYM_STRUCT:
+	case SYM_UNION: {
+		struct symbol *member;
+
+		printf(" {\n");
+		FOR_EACH_PTR(type->symbol_list, member) {
+			s2l_gen_struct_member(member);
+		} END_FOR_EACH_PTR(member);
+		printf("}\n");
+		break;
+	}
+
+	case SYM_FN: {
+		struct statement *stmt = type->stmt;
+		if (stmt) {
+			emit_func_pre(sym);
+			s2l_gen_statement(stmt);
+			emit_func_post(sym);
+		}
+		break;
+	}
+
+	default:
+		break;
+	}
+
+	if (sym->initializer && (type->type != SYM_BASETYPE) &&
+	    (type->type != SYM_ARRAY)) {
+		printf(" = \n");
+		s2l_gen_expression(sym->initializer);
+	}
+}
+
+static void s2l_gen_symbol_init(struct symbol *sym);
+
+static void s2l_gen_symbol_decl(struct symbol_list *syms)
+{
+	struct symbol *sym;
+	FOR_EACH_PTR(syms, sym) {
+		s2l_gen_symbol_init(sym);
+	} END_FOR_EACH_PTR(sym);
+}
+
+static void loopstk_push(int cont_lbl, int loop_bottom_lbl)
+{
+	struct function *f = current_func;
+	struct loop_stack *ls;
+
+	ls = malloc(sizeof(*ls));
+	ls->continue_lbl = cont_lbl;
+	ls->loop_bottom_lbl = loop_bottom_lbl;
+	ls->next = f->loop_stack;
+	f->loop_stack = ls;
+}
+
+static void loopstk_pop(void)
+{
+	struct function *f = current_func;
+	struct loop_stack *ls;
+
+	assert(f->loop_stack != NULL);
+	ls = f->loop_stack;
+	f->loop_stack = f->loop_stack->next;
+	free(ls);
+}
+
+static int loopstk_break(void)
+{
+	return current_func->loop_stack->loop_bottom_lbl;
+}
+
+static int loopstk_continue(void)
+{
+	return current_func->loop_stack->continue_lbl;
+}
+
+static void emit_loop(struct statement *stmt)
+{
+	struct statement  *pre_statement = stmt->iterator_pre_statement;
+	struct expression *pre_condition = stmt->iterator_pre_condition;
+	struct statement  *statement = stmt->iterator_statement;
+	struct statement  *post_statement = stmt->iterator_post_statement;
+	struct expression *post_condition = stmt->iterator_post_condition;
+	int loop_top = 0, loop_bottom, loop_continue;
+	int have_bottom = 0, dummy;
+	struct storage *val, *tmp;
+	char insnstr[128];
+	char stor_val[16], stor_tmp[16], stor_lbv[16];
+
+	loop_bottom = new_label();
+	loop_continue = new_label();
+	loopstk_push(loop_continue, loop_bottom);
+
+	s2l_gen_symbol_decl(stmt->iterator_syms);
+	s2l_gen_statement(pre_statement);
+
+	loop_top = new_label();
+	emit_label(loop_top, "loop top");
+
+	if (pre_condition) {
+		if (pre_condition->type == EXPR_VALUE) {
+			if (!pre_condition->value) {
+				struct storage *lbv;
+				lbv = new_storage(STOR_LABEL);
+				lbv->label = loop_bottom;
+				lbv->flags = STOR_WANTS_FREE;
+
+				sprintf(insnstr, "\tbr label %s\n",
+					stor_op_name(lbv));
+				push_text_atom(current_func, insnstr);
+
+				have_bottom = 1;
+			}
+		} else {
+			struct storage *lbv;
+
+			lbv = new_storage(STOR_LABEL);
+			lbv->label = loop_bottom;
+			lbv->flags = STOR_WANTS_FREE;
+			have_bottom = 1;
+
+			val = s2l_gen_expression(pre_condition);
+
+			tmp = stack_alloc(val->size);
+
+			strcpy(stor_val, stor_op_name(val));
+			strcpy(stor_tmp, stor_op_name(tmp));
+			strcpy(stor_lbv, stor_op_name(lbv));
+
+			sprintf(insnstr, "\t%s = icmp eq i%d 0, %s\n",
+				stor_tmp,
+				tmp->size * 8,
+				stor_val);
+			push_text_atom(current_func, insnstr);
+
+			dummy = new_label();
+
+			sprintf(insnstr, "\tbr i1 %s, label %s, label %%L%d\n",
+				stor_tmp,
+				stor_lbv,
+				dummy);
+			push_text_atom(current_func, insnstr);
+
+			emit_label(dummy, NULL);
+		}
+	}
+
+	s2l_gen_statement(statement);
+	if (stmt->iterator_continue->used)
+		emit_label(loop_continue, "'continue' iterator");
+	s2l_gen_statement(post_statement);
+	if (!post_condition) {
+		struct storage *lbv = new_storage(STOR_LABEL);
+		lbv->label = loop_top;
+		lbv->flags = STOR_WANTS_FREE;
+
+		sprintf(insnstr, "\tbr label %s\n", stor_op_name(lbv));
+		push_text_atom(current_func, insnstr);
+	} else if (post_condition->type == EXPR_VALUE) {
+		if (post_condition->value) {
+			struct storage *lbv = new_storage(STOR_LABEL);
+			lbv->label = loop_top;
+			lbv->flags = STOR_WANTS_FREE;
+
+			sprintf(insnstr, "\tbr label %s\n", stor_op_name(lbv));
+			push_text_atom(current_func, insnstr);
+		}
+	} else {
+		struct storage *lbv = new_storage(STOR_LABEL);
+		lbv->label = loop_top;
+		lbv->flags = STOR_WANTS_FREE;
+
+		val = s2l_gen_expression(post_condition);
+
+		tmp = stack_alloc(val->size);
+
+		strcpy(stor_val, stor_op_name(val));
+		strcpy(stor_tmp, stor_op_name(tmp));
+		strcpy(stor_lbv, stor_op_name(lbv));
+
+		sprintf(insnstr, "\t%s = icmp eq i%d 0, %s\n",
+			stor_tmp,
+			tmp->size * 8,
+			stor_val);
+		push_text_atom(current_func, insnstr);
+
+		dummy = new_label();
+
+		sprintf(insnstr, "\tbr i1 %s, label %s, label %%L%d\n",
+			stor_tmp,
+			stor_lbv,
+			dummy);
+		push_text_atom(current_func, insnstr);
+
+		emit_label(dummy, NULL);
+	}
+	if (have_bottom || stmt->iterator_break->used)
+		emit_label(loop_bottom, "loop bottom");
+
+	loopstk_pop();
+}
+
+static void emit_goto_statement(struct statement *stmt)
+{
+	char insnstr[128];
+
+	insnstr[0] = 0;
+
+	if (stmt->goto_expression) {
+		struct storage *val = s2l_gen_expression(stmt->goto_expression);
+		printf("\tFIXME goto *v%d\n", val->pseudo);
+	}
+
+	else if (!strcmp("break", show_ident(stmt->goto_label->ident))) {
+		struct storage *lbv = new_storage(STOR_LABEL);
+		lbv->label = loopstk_break();
+		lbv->flags = STOR_WANTS_FREE;
+
+		sprintf(insnstr, "\tbr label %s\n", stor_op_name(lbv));
+	}
+
+	else if (!strcmp("continue", show_ident(stmt->goto_label->ident))) {
+		struct storage *lbv = new_storage(STOR_LABEL);
+		lbv->label = loopstk_continue();
+		lbv->flags = STOR_WANTS_FREE;
+
+		sprintf(insnstr, "\tbr label %s\n", stor_op_name(lbv));
+	}
+
+	else {
+		struct storage *labelsym = new_labelsym(stmt->goto_label);
+
+		sprintf(insnstr, "\tbr label %s\n", stor_op_name(labelsym));
+	}
+
+	if (insnstr[0])
+		push_text_atom(current_func, insnstr);
+}
+
+/*
+ * Print out a statement
+ */
+static struct storage *s2l_gen_statement(struct statement *stmt)
+{
+	if (!stmt)
+		return NULL;
+	switch (stmt->type) {
+	default:
+		return NULL;
+	case STMT_RETURN:
+		return emit_return_stmt(stmt);
+	case STMT_DECLARATION:
+		s2l_gen_symbol_decl(stmt->declaration);
+		break;
+	case STMT_COMPOUND: {
+		struct statement *s;
+		struct storage *last = NULL;
+
+		FOR_EACH_PTR(stmt->stmts, s) {
+			last = s2l_gen_statement(s);
+		} END_FOR_EACH_PTR(s);
+
+		return last;
+	}
+
+	case STMT_EXPRESSION:
+		return s2l_gen_expression(stmt->expression);
+	case STMT_IF:
+		emit_if_conditional(stmt);
+		return NULL;
+
+	case STMT_CASE:
+		emit_case_statement(stmt);
+		break;
+	case STMT_SWITCH:
+		emit_switch_statement(stmt);
+		break;
+
+	case STMT_ITERATOR:
+		emit_loop(stmt);
+		break;
+
+	case STMT_NONE:
+		break;
+
+	case STMT_LABEL:
+		printf(".L%p:\n", stmt->label_identifier);
+		s2l_gen_statement(stmt->label_statement);
+		break;
+
+	case STMT_GOTO:
+		emit_goto_statement(stmt);
+		break;
+	case STMT_ASM:
+		printf("\tasm( .... )\n");
+		break;
+	}
+	return NULL;
+}
+
+static struct storage *s2l_gen_call_expression(struct expression *expr)
+{
+	struct symbol *direct;
+	struct expression *arg, *fn;
+	struct storage *retval, *fncall;
+	int first_arg = 1;
+	char s[64];
+	char arg_str[1024];
+	char callstr[1024];
+
+	if (!expr->ctype) {
+		warning(expr->pos, "\tcall with no type!");
+		return NULL;
+	}
+
+	retval = stack_alloc(expr->ctype->bit_size / 8);
+
+	arg_str[0] = 0;
+
+	sprintf(callstr, "\t%s = call i%d ",
+		stor_op_name(retval),
+		expr->ctype->bit_size);
+
+	FOR_EACH_PTR(expr->args, arg) {
+		struct storage *new = s2l_gen_expression(arg);
+		int size = arg->ctype->bit_size;
+
+		/*
+		 * FIXME: i386 SysV ABI dictates that values
+		 * smaller than 32 bits should be placed onto
+		 * the stack as 32-bit objects.  We should not
+		 * blindly do a 32-bit push on objects smaller
+		 * than 32 bits.
+		 */
+		if (size < 32)
+			size = 32;
+
+		sprintf(s, "%si%d %s",
+			first_arg ? "" : ", ",
+			size,
+			stor_op_name(new));
+
+		strcat(arg_str, s);
+
+		first_arg = 0;
+	} END_FOR_EACH_PTR(arg);
+
+	fn = expr->fn;
+
+	/* Remove dereference, if any */
+	direct = NULL;
+	if (fn->type == EXPR_PREOP) {
+		if (fn->unop->type == EXPR_SYMBOL) {
+			struct symbol *sym = fn->unop->symbol;
+			if (sym->ctype.base_type->type == SYM_FN)
+				direct = sym;
+		}
+	}
+	if (direct) {
+		struct storage *direct_stor = new_storage(STOR_SYM);
+		direct_stor->flags |= STOR_WANTS_FREE;
+		direct_stor->sym = direct;
+
+		sprintf(s, "@%s(", stor_op_name(direct_stor));
+		strcat(callstr, s);
+	} else {
+		fncall = s2l_gen_expression(fn);
+
+		sprintf(s, "%%%s(", stor_op_name(fncall));
+		strcat(callstr, s);
+	}
+
+	strcat(callstr, arg_str);
+	strcat(callstr, ")\n");
+	push_text_atom(current_func, callstr);
+
+	return retval;
+}
+
+static struct storage *s2l_gen_address_gen(struct expression *expr)
+{
+	struct storage *addr;
+	struct storage *new;
+	int bits = expr->ctype->bit_size;
+	char insnstr[128];
+	char stor_addr[16], stor_new[16];
+
+	addr = s2l_gen_expression(expr->unop);
+	if (expr->unop->type == EXPR_SYMBOL)
+		return addr;
+
+	new = stack_alloc(bits / 8);
+
+	strcpy(stor_new, stor_op_name(new));
+	strcpy(stor_addr, stor_op_name(addr));
+
+	sprintf(insnstr, "\t%s = load i%d* %s\n",
+		stor_new,
+		bits,
+		stor_addr);
+	push_text_atom(current_func, insnstr);
+
+	return new;
+}
+
+static struct storage *s2l_gen_assignment(struct expression *expr)
+{
+	struct expression *target = expr->left;
+	struct storage *val, *addr;
+
+	if (!expr->ctype)
+		return NULL;
+
+	val = s2l_gen_expression(expr->right);
+	addr = s2l_gen_address_gen(target);
+
+	switch (val->type) {
+	/* copy, where both operands are memory */
+	case STOR_PSEUDO:
+	case STOR_ARG:
+		emit_copy(val, addr, expr->ctype);
+		break;
+
+	/* copy, one or zero operands are memory */
+	case STOR_SYM:
+	case STOR_VALUE:
+	case STOR_LABEL:
+		emit_move(val, addr, expr->left->ctype, NULL);
+		break;
+
+	case STOR_LABELSYM:
+		assert(0);
+		break;
+	}
+	return val;
+}
+
+static int s2l_gen_initialization(struct symbol *sym, struct expression *expr)
+{
+	struct storage *val, *addr;
+	int bits;
+
+	if (!expr->ctype)
+		return 0;
+
+	bits = expr->ctype->bit_size;
+	val = s2l_gen_expression(expr);
+	addr = s2l_gen_symbol_expr(sym);
+	// FIXME! The "target" expression is for bitfield store information.
+	// Leave it NULL, which works fine.
+	emit_store(NULL, addr, val, bits);
+	return 0;
+}
+
+static struct storage *s2l_gen_access(struct expression *expr)
+{
+	return s2l_gen_address_gen(expr);
+}
+
+static struct storage *s2l_gen_preop(struct expression *expr)
+{
+	/*
+	 * '*' is an lvalue access, and is fundamentally different
+	 * from an arithmetic operation. Maybe it should have an
+	 * expression type of its own..
+	 */
+	if (expr->op == '*')
+		return s2l_gen_access(expr);
+	if (expr->op == SPECIAL_INCREMENT || expr->op == SPECIAL_DECREMENT)
+		return emit_inc_dec(expr, 0);
+	return emit_regular_preop(expr);
+}
+
+static struct storage *s2l_gen_symbol_expr(struct symbol *sym)
+{
+	struct storage *new = stack_alloc(4);
+
+	if (sym->ctype.modifiers & (MOD_TOPLEVEL | MOD_EXTERN | MOD_STATIC)) {
+		printf("\tmovi.%d\t\tv%d,$%s\n", bits_in_pointer, new->pseudo, show_ident(sym->ident));
+		return new;
+	}
+	if (sym->ctype.modifiers & MOD_ADDRESSABLE) {
+		printf("\taddi.%d\t\tv%d,vFP,$%lld\n", bits_in_pointer, new->pseudo, sym->value);
+		return new;
+	}
+	printf("\taddi.%d\t\tv%d,vFP,$offsetof(%s:%p)\n", bits_in_pointer, new->pseudo, show_ident(sym->ident), sym);
+	return new;
+}
+
+static void s2l_gen_symbol_init(struct symbol *sym)
+{
+	struct symbol_private *priv = sym->aux;
+	struct expression *expr = sym->initializer;
+	struct storage *new;
+
+	new = stack_alloc(sym->bit_size / 8);
+	if (expr) {
+		struct storage *val;
+
+		val = s2l_gen_expression(expr);
+
+		emit_copy(val, new, expr->ctype);
+	}
+
+	if (!priv) {
+		priv = calloc(1, sizeof(*priv));
+		sym->aux = priv;
+		/* FIXME: leak! we don't free... */
+		/* (well, we don't free symbols either) */
+	}
+
+	priv->addr = new;
+}
+
+static int type_is_signed(struct symbol *sym)
+{
+	if (sym->type == SYM_NODE)
+		sym = sym->ctype.base_type;
+	if (sym->type == SYM_PTR)
+		return 0;
+	return !(sym->ctype.modifiers & MOD_UNSIGNED);
+}
+
+static struct storage *s2l_gen_label_expr(struct expression *expr)
+{
+	struct storage *new = stack_alloc(4);
+	printf("\tmovi.%d\t\tv%d,.L%p\n", bits_in_pointer, new->pseudo, expr->label_symbol);
+	return new;
+}
+
+static struct storage *s2l_gen_statement_expr(struct expression *expr)
+{
+	return s2l_gen_statement(expr->statement);
+}
+
+static int s2l_gen_position_expr(struct expression *expr, struct symbol *base)
+{
+	struct storage *new = s2l_gen_expression(expr->init_expr);
+	struct symbol *ctype = expr->init_expr->ctype;
+
+	printf("\tinsert v%d at [%d:%d] of %s\n", new->pseudo,
+		expr->init_offset, ctype->bit_offset,
+		show_ident(base->ident));
+	return 0;
+}
+
+static void s2l_gen_initializer_expr(struct expression *expr, struct symbol *ctype)
+{
+	struct expression *entry;
+
+	FOR_EACH_PTR(expr->expr_list, entry) {
+		// Nested initializers have their positions already
+		// recursively calculated - just output them too
+		if (entry->type == EXPR_INITIALIZER) {
+			s2l_gen_initializer_expr(entry, ctype);
+			continue;
+		}
+
+		// Ignore initializer indexes and identifiers - the
+		// evaluator has taken them into account
+		if (entry->type == EXPR_IDENTIFIER || entry->type == EXPR_INDEX)
+			continue;
+		if (entry->type == EXPR_POS) {
+			s2l_gen_position_expr(entry, ctype);
+			continue;
+		}
+		s2l_gen_initialization(ctype, entry);
+	} END_FOR_EACH_PTR(entry);
+}
+
+/*
+ * Print out an expression. Return the pseudo that contains the
+ * variable.
+ */
+static struct storage *s2l_gen_expression(struct expression *expr)
+{
+	if (!expr)
+		return NULL;
+
+	if (!expr->ctype) {
+		struct position *pos = &expr->pos;
+		printf("\tno type at %s:%d:%d\n",
+			stream_name(pos->stream),
+			pos->line, pos->pos);
+		return NULL;
+	}
+
+	switch (expr->type) {
+	default:
+		return NULL;
+	case EXPR_CALL:
+		return s2l_gen_call_expression(expr);
+
+	case EXPR_ASSIGNMENT:
+		return s2l_gen_assignment(expr);
+
+	case EXPR_COMPARE:
+		return emit_compare(expr);
+	case EXPR_BINOP:
+	case EXPR_COMMA:
+	case EXPR_LOGICAL:
+		return emit_binop(expr);
+	case EXPR_PREOP:
+		return s2l_gen_preop(expr);
+	case EXPR_POSTOP:
+		return emit_postop(expr);
+	case EXPR_SYMBOL:
+		return emit_symbol_expr_init(expr->symbol);
+	case EXPR_DEREF:
+	case EXPR_SIZEOF:
+	case EXPR_ALIGNOF:
+		warning(expr->pos, "invalid expression after evaluation");
+		return NULL;
+	case EXPR_CAST:
+	case EXPR_FORCE_CAST:
+	case EXPR_IMPLIED_CAST:
+		return emit_cast_expr(expr);
+	case EXPR_VALUE:
+		return emit_value(expr);
+	case EXPR_STRING:
+		return emit_string_expr(expr);
+	case EXPR_INITIALIZER:
+		s2l_gen_initializer_expr(expr, expr->ctype);
+		return NULL;
+	case EXPR_SELECT:
+	case EXPR_CONDITIONAL:
+		return emit_conditional_expr(expr);
+	case EXPR_STATEMENT:
+		return s2l_gen_statement_expr(expr);
+	case EXPR_LABEL:
+		return s2l_gen_label_expr(expr);
+
+	// None of these should exist as direct expressions: they are only
+	// valid as sub-expressions of initializers.
+	case EXPR_POS:
+		warning(expr->pos, "unable to show plain initializer position expression");
+		return NULL;
+	case EXPR_IDENTIFIER:
+		warning(expr->pos, "unable to show identifier expression");
+		return NULL;
+	case EXPR_INDEX:
+		warning(expr->pos, "unable to show index expression");
+		return NULL;
+	case EXPR_TYPE:
+		warning(expr->pos, "unable to show type expression");
+		return NULL;
+	case EXPR_FVALUE:
+		warning(expr->pos, "floating point support is not implemented");
+		return NULL;
+	}
+	return NULL;
+}
diff --git a/s2l.c b/s2l.c
new file mode 100644
index 0000000..adba48a
--- /dev/null
+++ b/s2l.c
@@ -0,0 +1,77 @@
+/*
+ * client program that uses the sparse library and LLVM.
+ *
+ * Copyright (C) 2003 Transmeta Corp.
+ *               2003 Linus Torvalds
+ * Copyright 2003 Jeff Garzik
+ * Copyright 2009 Red Hat, Inc.
+ *
+ *  Licensed under the Open Software License version 1.1
+ *
+ *
+ * Example usage:
+ *
+ *	./s2l -I/usr/local/include -DHARPSICHORD myfile.c > myfile.ll
+ *	llvm-as myfile.ll	# produces myfile.bc
+ *	llc myfile.bc		# produces myfile.s, target-specific asm
+ *	as -o myfile.o myfile.s	# GNU assembler for the final step
+ *
+ */
+#include <stdarg.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <ctype.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include "lib.h"
+#include "allocate.h"
+#include "token.h"
+#include "parse.h"
+#include "symbol.h"
+#include "expression.h"
+#include "compile.h"
+
+static void clean_up_symbols(struct symbol_list *list)
+{
+	struct symbol *sym;
+
+	FOR_EACH_PTR(list, sym) {
+		expand_symbol(sym);
+		emit_one_symbol(sym);
+	} END_FOR_EACH_PTR(sym);
+}
+
+int main(int argc, char **argv)
+{
+	char *file;
+	struct string_list *filelist = NULL;
+
+	clean_up_symbols(sparse_initialize(argc, argv, &filelist));
+	add_pre_buffer("#define __x86_64__ 1\n");
+	FOR_EACH_PTR_NOTAG(filelist, file) {
+		struct symbol_list *list;
+		const char *basename = strrchr(file, '/');
+		basename = basename ?  basename+1 : file;
+
+		list = sparse(file);
+
+		// Do type evaluation and simplification
+		emit_unit_begin(basename);
+		clean_up_symbols(list);
+		emit_unit_end();
+	} END_FOR_EACH_PTR_NOTAG(file);
+
+#if 0
+	// And show the allocation statistics
+	show_ident_alloc();
+	show_token_alloc();
+	show_symbol_alloc();
+	show_expression_alloc();
+	show_statement_alloc();
+	show_string_alloc();
+	show_bytes_alloc();
+#endif
+	return 0;
+}

--------------050606020802010008000702--
