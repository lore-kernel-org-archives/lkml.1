Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbZJKXAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbZJKXAF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752737AbZJKXAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:00:04 -0400
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:35503 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752697AbZJKXAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:00:01 -0400
Date: Sun, 11 Oct 2009 15:51:56 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-sparse@vger.kernel.org
Cc: sparse@chrisli.org, linux-kernel@vger.kernel.org,
       paulmck@linux.vnet.ibm.com
Subject: [PATCHv3] New attribute designated_init: mark a struct as
 requiring designated init
Message-ID: <20091011225151.GA4212@feather>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some structure types provide a set of fields of which most users will
only initialize the subset they care about.  Users of these types should
always use designated initializers, to avoid relying on the specific
structure layout.  Examples of this type of structure include the many
*_operations structures in Linux, which contain a set of function
pointers; these structures occasionally gain a new field, lose an
obsolete field, or change the function signature for a field.

Add a new attribute designated_init; when used on a struct, it tells
Sparse to warn on any positional initialization of a field in that
struct.

The new flag -Wdesignated-init controls these warnings.  Since these
warnings only fire for structures explicitly tagged with the attribute,
enable the warning by default.

Includes documentation and test case.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

v3: Add Wdesignated-init to cgcc's list of sparse warning options.  Note
that because of this change, this patch depends on my Wsparse-all patch,
to avoid conflicts.

v2: Fixed printing of ->ident to not rely on terminating NUL, as noticed
by Chris Li.

 cgcc                         |    2 +-
 evaluate.c                   |   10 ++
 lib.c                        |    2 +
 lib.h                        |    1 +
 parse.c                      |   15 +++
 sparse.1                     |   24 +++++
 symbol.h                     |    3 +-
 validation/designated-init.c |  195 ++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 250 insertions(+), 2 deletions(-)
 create mode 100644 validation/designated-init.c

diff --git a/cgcc b/cgcc
index 8005c3c..d37cf88 100755
--- a/cgcc
+++ b/cgcc
@@ -88,7 +88,7 @@ exit 0;
 
 sub check_only_option {
     my ($arg) = @_;
-    return 1 if $arg =~ /^-W(no-?)?(default-bitfield-sign|one-bit-signed-bitfield|cast-truncate|bitwise|typesign|context|undef|ptr-subtraction-blows|cast-to-as|decl|transparent-union|address-space|enum-mismatch|do-while|old-initializer|non-pointer-null|paren-string|return-void|sparse-all)$/;
+    return 1 if $arg =~ /^-W(no-?)?(default-bitfield-sign|one-bit-signed-bitfield|cast-truncate|bitwise|typesign|context|undef|ptr-subtraction-blows|cast-to-as|decl|transparent-union|address-space|enum-mismatch|do-while|old-initializer|non-pointer-null|paren-string|return-void|designated-init|sparse-all)$/;
     return 1 if $arg =~ /^-v(no-?)?(entry|dead)$/;
     return 0;
 }
diff --git a/evaluate.c b/evaluate.c
index 805ae90..28bfd7c 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -2366,6 +2366,7 @@ static void handle_list_initializer(struct expression *expr,
 		int lclass;
 
 		if (e->type != EXPR_INDEX && e->type != EXPR_IDENTIFIER) {
+			struct symbol *struct_sym;
 			if (!top) {
 				top = e;
 				last = first_subobject(ctype, class, &top);
@@ -2378,6 +2379,15 @@ static void handle_list_initializer(struct expression *expr,
 				DELETE_CURRENT_PTR(e);
 				continue;
 			}
+			struct_sym = ctype->type == SYM_NODE ? ctype->ctype.base_type : ctype;
+			if (Wdesignated_init && struct_sym->designated_init)
+				warning(e->pos, "%s%.*s%spositional init of field in %s %s, declared with attribute designated_init",
+					ctype->ident ? "in initializer for " : "",
+					ctype->ident ? ctype->ident->len : 0,
+					ctype->ident ? ctype->ident->name : "",
+					ctype->ident ? ": " : "",
+					get_type_name(struct_sym->type),
+					show_ident(struct_sym->ident));
 			if (jumped) {
 				warning(e->pos, "advancing past deep designator");
 				jumped = 0;
diff --git a/lib.c b/lib.c
index 963be08..9777826 100644
--- a/lib.c
+++ b/lib.c
@@ -197,6 +197,7 @@ int Wcast_truncate = 1;
 int Wcontext = 1;
 int Wdecl = 1;
 int Wdefault_bitfield_sign = 0;
+int Wdesignated_init = 1;
 int Wdo_while = 0;
 int Wenum_mismatch = 1;
 int Wnon_pointer_null = 1;
@@ -378,6 +379,7 @@ static const struct warning {
 	{ "context", &Wcontext },
 	{ "decl", &Wdecl },
 	{ "default-bitfield-sign", &Wdefault_bitfield_sign },
+	{ "designated-init", &Wdesignated_init },
 	{ "do-while", &Wdo_while },
 	{ "enum-mismatch", &Wenum_mismatch },
 	{ "non-pointer-null", &Wnon_pointer_null },
diff --git a/lib.h b/lib.h
index 25abb80..3ced1bf 100644
--- a/lib.h
+++ b/lib.h
@@ -97,6 +97,7 @@ extern int Wcast_truncate;
 extern int Wcontext;
 extern int Wdecl;
 extern int Wdefault_bitfield_sign;
+extern int Wdesignated_init;
 extern int Wdo_while;
 extern int Wenum_mismatch;
 extern int Wnon_pointer_null;
diff --git a/parse.c b/parse.c
index 5e75242..03fa5d9 100644
--- a/parse.c
+++ b/parse.c
@@ -64,6 +64,7 @@ typedef struct token *attr_t(struct token *, struct symbol *,
 static attr_t
 	attribute_packed, attribute_aligned, attribute_modifier,
 	attribute_address_space, attribute_context,
+	attribute_designated_init,
 	attribute_transparent_union, ignore_attribute,
 	attribute_mode, attribute_force;
 
@@ -319,6 +320,10 @@ static struct symbol_op context_op = {
 	.attribute = attribute_context,
 };
 
+static struct symbol_op designated_init_op = {
+	.attribute = attribute_designated_init,
+};
+
 static struct symbol_op transparent_union_op = {
 	.attribute = attribute_transparent_union,
 };
@@ -453,6 +458,7 @@ static struct init_keyword {
 	{ "address_space",NS_KEYWORD,	.op = &address_space_op },
 	{ "mode",	NS_KEYWORD,	.op = &mode_op },
 	{ "context",	NS_KEYWORD,	.op = &context_op },
+	{ "designated_init",	NS_KEYWORD,	.op = &designated_init_op },
 	{ "__transparent_union__",	NS_KEYWORD,	.op = &transparent_union_op },
 
 	{ "__mode__",	NS_KEYWORD,	.op = &mode_op },
@@ -1127,6 +1133,15 @@ static struct token *attribute_context(struct token *token, struct symbol *attr,
 	return token;
 }
 
+static struct token *attribute_designated_init(struct token *token, struct symbol *attr, struct decl_state *ctx)
+{
+	if (ctx->ctype.base_type && ctx->ctype.base_type->type == SYM_STRUCT)
+		ctx->ctype.base_type->designated_init = 1;
+	else
+		warning(token->pos, "attribute designated_init applied to non-structure type");
+	return token;
+}
+
 static struct token *attribute_transparent_union(struct token *token, struct symbol *attr, struct decl_state *ctx)
 {
 	if (Wtransparent_union)
diff --git a/sparse.1 b/sparse.1
index abc75a2..bde6b6d 100644
--- a/sparse.1
+++ b/sparse.1
@@ -138,6 +138,30 @@ explicitly.
 Sparse does not issue these warnings by default.
 .
 .TP
+.B \-Wdesignated\-init
+Warn about positional initialization of structs marked as requiring designated
+initializers.
+
+Sparse allows an attribute
+.BI __attribute__((designated_init))
+which marks a struct as requiring designated initializers.  Sparse will warn
+about positional initialization of a struct variable or struct literal of a
+type that has this attribute.
+
+Requiring designated initializers for a particular struct type will insulate
+code using that struct type from changes to the layout of the type, avoiding
+the need to change initializers for that type unless they initialize a removed
+or incompatibly changed field.
+
+Common examples of this type of struct include collections of function pointers
+for the implementations of a class of related operations, for which the default
+NULL for an unmentioned field in a designated initializer will correctly
+indicate the absence of that operation.
+
+Sparse issues these warnings by default.  To turn them off, use
+\fB\-Wno\-designated\-init\fR.
+.
+.TP
 .B \-Wdo\-while
 Warn about do-while loops that do not delimit the loop body with braces.
 
diff --git a/symbol.h b/symbol.h
index 60fdad0..83b3d4b 100644
--- a/symbol.h
+++ b/symbol.h
@@ -156,7 +156,8 @@ struct symbol {
 					examined:1,
 					expanding:1,
 					evaluated:1,
-					string:1;
+					string:1,
+					designated_init:1;
 			struct expression *array_size;
 			struct ctype ctype;
 			struct symbol_list *arguments;
diff --git a/validation/designated-init.c b/validation/designated-init.c
new file mode 100644
index 0000000..23423e9
--- /dev/null
+++ b/validation/designated-init.c
@@ -0,0 +1,195 @@
+struct s1 {
+	int x;
+	int y;
+};
+
+struct s2 {
+	int x;
+	int y;
+} __attribute__((designated_init));
+
+struct nest1 {
+	struct s1 s1;
+	struct s2 s2;
+};
+
+struct nest2 {
+	struct s1 s1;
+	struct s2 s2;
+} __attribute__((designated_init));
+
+static struct s1 s1_positional = { 5, 10 };
+static struct s1 s1_designated = { .x = 5, .y = 10 };
+static struct s2 s2_positional = { 5, 10 };
+static struct s2 s2_designated = { .x = 5, .y = 10 };
+static struct nest1 nest1_positional = {
+	{ 5, 10 },
+	{ 5, 10 },
+};
+static struct nest1 nest1_designated_outer = {
+	.s1 = { 5, 10 },
+	.s2 = { 5, 10 },
+};
+static struct nest1 nest1_designated_inner = {
+	{ .x = 5, .y = 10 },
+	{ .x = 5, .y = 10 },
+};
+static struct nest1 nest1_designated_both = {
+	.s1 = { .x = 5, .y = 10 },
+	.s2 = { .x = 5, .y = 10 },
+};
+static struct nest2 nest2_positional = {
+	{ 5, 10 },
+	{ 5, 10 },
+};
+static struct nest2 nest2_designated_outer = {
+	.s1 = { 5, 10 },
+	.s2 = { 5, 10 },
+};
+static struct nest2 nest2_designated_inner = {
+	{ .x = 5, .y = 10 },
+	{ .x = 5, .y = 10 },
+};
+static struct nest2 nest2_designated_both = {
+	.s1 = { .x = 5, .y = 10 },
+	.s2 = { .x = 5, .y = 10 },
+};
+
+static struct {
+	int x;
+	int y;
+} __attribute__((designated_init))
+	anon_positional = { 5, 10 },
+	anon_designated = { .x = 5, .y = 10};
+
+static struct s1 s1_array[] = {
+	{ 5, 10 },
+	{ .x = 5, .y = 10 },
+};
+
+static struct s2 s2_array[] = {
+	{ 5, 10 },
+	{ .x = 5, .y = 10 },
+};
+
+static struct s1 ret_s1_positional(void)
+{
+	return ((struct s1){ 5, 10 });
+}
+
+static struct s1 ret_s1_designated(void)
+{
+	return ((struct s1){ .x = 5, .y = 10 });
+}
+
+static struct s2 ret_s2_positional(void)
+{
+	return ((struct s2){ 5, 10 });
+}
+
+static struct s2 ret_s2_designated(void)
+{
+	return ((struct s2){ .x = 5, .y = 10 });
+}
+
+static struct nest1 ret_nest1_positional(void)
+{
+	return ((struct nest1){
+			{ 5, 10 },
+			{ 5, 10 },
+		});
+}
+
+static struct nest1 ret_nest1_designated_outer(void)
+{
+	return ((struct nest1){
+			.s1 = { 5, 10 },
+			.s2 = { 5, 10 },
+		});
+}
+
+static struct nest1 ret_nest1_designated_inner(void)
+{
+	return ((struct nest1){
+			{ .x = 5, .y = 10 },
+			{ .x = 5, .y = 10 },
+		});
+}
+
+static struct nest1 ret_nest1_designated_both(void)
+{
+	return ((struct nest1){
+			.s1 = { .x = 5, .y = 10 },
+			.s2 = { .x = 5, .y = 10 },
+		});
+}
+
+static struct nest2 ret_nest2_positional(void)
+{
+	return ((struct nest2){
+			{ 5, 10 },
+			{ 5, 10 },
+		});
+}
+
+static struct nest2 ret_nest2_designated_outer(void)
+{
+	return ((struct nest2){
+			.s1 = { 5, 10 },
+			.s2 = { 5, 10 },
+		});
+}
+
+static struct nest2 ret_nest2_designated_inner(void)
+{
+	return ((struct nest2){
+			{ .x = 5, .y = 10 },
+			{ .x = 5, .y = 10 },
+		});
+}
+
+static struct nest2 ret_nest2_designated_both(void)
+{
+	return ((struct nest2){
+			.s1 = { .x = 5, .y = 10 },
+			.s2 = { .x = 5, .y = 10 },
+		});
+}
+/*
+ * check-name: designated_init attribute
+ *
+ * check-error-start
+designated-init.c:23:36: warning: in initializer for s2_positional: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:23:39: warning: in initializer for s2_positional: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:27:11: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:27:14: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:31:17: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:31:20: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:42:9: warning: in initializer for nest2_positional: positional init of field in struct nest2, declared with attribute designated_init
+designated-init.c:43:9: warning: in initializer for nest2_positional: positional init of field in struct nest2, declared with attribute designated_init
+designated-init.c:43:11: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:43:14: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:47:17: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:47:20: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:50:9: warning: in initializer for nest2_designated_inner: positional init of field in struct nest2, declared with attribute designated_init
+designated-init.c:51:9: warning: in initializer for nest2_designated_inner: positional init of field in struct nest2, declared with attribute designated_init
+designated-init.c:62:29: warning: in initializer for anon_positional: positional init of field in struct <noident>, declared with attribute designated_init
+designated-init.c:62:32: warning: in initializer for anon_positional: positional init of field in struct <noident>, declared with attribute designated_init
+designated-init.c:71:11: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:71:14: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:87:30: warning: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:87:33: warning: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:99:27: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:99:30: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:107:33: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:107:36: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:130:25: warning: positional init of field in struct nest2, declared with attribute designated_init
+designated-init.c:131:25: warning: positional init of field in struct nest2, declared with attribute designated_init
+designated-init.c:131:27: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:131:30: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:139:33: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:139:36: warning: in initializer for s2: positional init of field in struct s2, declared with attribute designated_init
+designated-init.c:146:25: warning: positional init of field in struct nest2, declared with attribute designated_init
+designated-init.c:147:25: warning: positional init of field in struct nest2, declared with attribute designated_init
+ * check-error-end
+ */
-- 
1.6.4.3

