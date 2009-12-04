Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbZLDNzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbZLDNzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:55:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756637AbZLDNzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:55:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756443AbZLDNzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:55:52 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [RFC PATCH] tracing - moving some of recordmcount functionality to binary
Date: Fri,  4 Dec 2009 14:55:45 +0100
Message-Id: <1259934945-18305-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I noticed on some discussion, that it might speedup the FTRACE build process,
if some of the 'scripts/recordmcount.pl' functionality was done in binary,
instead of in the script using nm/.objdump output.


Before I dive into details, to sum it up:
- i wrote tool which took over some of the 'recordmcount.pl' stuff
- with 'allyesconfig' the build was faster about 2 minutes

I'm not sure wether it's worth to continue in this effort,
but I at least provide some details to have some enclosure.. :)


recordmcount does very roughly this:
(for details plz see the doc in the script itself)

- is executed on each object after it is compiled by gcc

1) get object's symbols using 'nm' tool
2) run 'objdump -hdr' to get object's disassembly mixed with relocations
3) parse (2) output looking for 'mcount' relocations and reference symbols
4) based on (3) produce assembly code with __mcount_loc section
5) compile the (4) assembly
6) link the (5) object with the original object + optional local->global->local game :)


My first idea was to cover all these steps in binary, but as I studied objcopy/objdump,
this turned up not to be the best idea.

The reason I saw was that any time objcopy wanted to change anything in object file,
it manages this by copying the whole object to the new one (section by section...)
changing the requested stuff (eg make global symbol to local) as it goes.

As there were tons of stuff to check/copy/manage I dont thing this was suitable.


So I ended up with only some steps. I took steps: 1), 2), 3) and 4). 
The mctool I created locates all the mcount relocations and provides 
the assemble output.


I investigated 'libbfd' and 'libelf' and endup with 'libbfd'.  For the tool I wrote
I think it does not matter, since both have reasonable interface for getting info 
out of the objects. It might be different for actually changing the object.


My opinion is that having this part in binary is better than having
it parsed out of objdump. I haven't check the tool on other archs,
bu I assume it should work properly.


As I said above I did not get much build speedup, so unless I get some
possitive feedback I consider this as a deadend for me :)


The attached patch is not by all means final in any way,
it's just working... tested on x86_64 :)


thanks for any feedback,
jirka


---
diff --git a/scripts/Makefile b/scripts/Makefile
index 842dbc2..ddda6cd 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -6,11 +6,13 @@
 # pnmttologo:    Convert pnm files to logo files
 # conmakehash:   Create chartable
 # conmakehash:	 Create arrays for initializing the kernel console tables
+# mctool:	 Create mcount section for tracing
 
 hostprogs-$(CONFIG_KALLSYMS)     += kallsyms
 hostprogs-$(CONFIG_LOGO)         += pnmtologo
 hostprogs-$(CONFIG_VT)           += conmakehash
 hostprogs-$(CONFIG_IKCONFIG)     += bin2c
+hostprogs-$(CONFIG_FTRACE)       += mctool
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
@@ -22,5 +24,7 @@ subdir-y                     += mod
 subdir-$(CONFIG_SECURITY_SELINUX) += selinux
 subdir-$(CONFIG_DTC)         += dtc
 
+HOSTLOADLIBES_mctool:= -lbfd
+
 # Let clean descend into subdirs
 subdir-	+= basic kconfig package selinux
diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 341b589..110b3a6 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -208,7 +208,7 @@ endif
 ifdef CONFIG_FTRACE_MCOUNT_RECORD
 cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
 	"$(if $(CONFIG_64BIT),64,32)" \
-	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
+	"$(srctree)/scripts/mctool" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(RM)" "$(MV)" \
 	"$(if $(part-of-module),1,0)" "$(@)";
 endif
 
diff --git a/scripts/mctool.c b/scripts/mctool.c
new file mode 100644
index 0000000..3c0710d
--- /dev/null
+++ b/scripts/mctool.c
@@ -0,0 +1,470 @@
+
+#include <stdio.h>
+#include <bfd.h>
+#include <getopt.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <search.h>
+#include <string.h>
+
+static char *filename_in      = NULL;
+static char *filename_out     = NULL;
+static char *filename_convert = NULL;
+static char *data_type        = NULL;
+static char *section_type     = NULL;
+static char *section_align    = NULL;
+static char *section_name     = NULL;
+static int   verbose          = 0;
+
+static bfd       *bfd_in      = NULL;
+static FILE     *file_out     = NULL;
+static asymbol **symbol_table = NULL;
+
+#define MCTOOL_VERSION "0.1"
+
+#define PRINT(fmt, args...) \
+do { \
+	char lpbuf[1024]; \
+	sprintf(lpbuf, "[%s:%05d] %s", \
+		__FUNCTION__, \
+		__LINE__, \
+		fmt); \
+	printf(lpbuf, ## args); \
+	fflush(NULL); \
+} while(0)
+
+#define PRINT_VERBOSE(cond, fmt, args...) \
+do { \
+	if (cond > verbose) \
+		break; \
+	PRINT(fmt, ## args); \
+} while(0)
+
+
+struct section_st {
+	char    *name;
+	asymbol *ref_sym;
+	int      used;
+};
+
+static struct section_st safe_sections[] = {
+	{ .name = ".text" },
+	{ .name = ".sched.text" },
+	{ .name = ".spinlock.text" },
+	{ .name = ".irqentry.text" },
+	{ .name = ".text.unlikely" },
+};
+
+#define SAFE_SECTIONS_COUNT (sizeof(safe_sections) / sizeof(struct section_st))
+
+static struct section_st* section_find(const char *name)
+{
+	int i;
+
+	for(i = 0; i < SAFE_SECTIONS_COUNT; i++) {
+		if (!strcmp(name, safe_sections[i].name))
+			return &safe_sections[i];
+	}
+
+	return NULL;
+}
+
+static void usage(void)
+{
+	printf("usage: mctool [-vVhtTacon] <object>\n");
+	_exit(1);
+}
+
+static int process_args(int argc, char **argv)
+{
+	while (1) {
+		int c;
+		int option_index = 0;
+		static struct option long_options[] = {
+			{"output", required_argument, 0, 'o'},
+			{"data-type", required_argument, 0, 't'},
+			{"section-type", required_argument, 0, 'T'},
+			{"section-align", required_argument, 0, 'a'},
+			{"section-name", required_argument, 0, 'n'},
+			{"convert", required_argument, 0, 'c'},
+			{"verbose", no_argument, 0, 'v'},
+			{"version", no_argument, 0, 'V'},
+			{"help", no_argument, 0, 'h'},
+			{0, 0, 0, 0}
+		};
+
+		c = getopt_long(argc, argv, "+vVht:T:a:c:o:n:",
+				long_options, &option_index);
+
+		if (c == -1)
+			break;
+
+		switch (c) {
+		case 'v':
+			verbose++;
+			break;
+
+		case 'V':
+			printf("mctool " MCTOOL_VERSION "\n");
+			_exit(1);
+
+		case 'o':
+			filename_out = optarg;
+			break;
+
+		case 'T':
+			section_type = optarg;
+			break;
+
+		case 't':
+			data_type = optarg;
+			break;
+
+		case 'a':
+			section_align = optarg;
+			break;
+
+		case 'n':
+			section_name = optarg;
+			break;
+
+		case 'c':
+			filename_convert = optarg;
+			break;
+
+                case 'h':
+			usage();
+                        break;
+		};
+	};
+
+	if (optind < argc) {
+		filename_in = argv[optind++];
+        } else {
+		printf("no input file specified\n");
+		return 1;
+	}
+
+	if (optind < argc) {
+		printf("only one input file supported\n");
+		return 1;
+	}
+
+	if (!section_type ||
+	    !data_type ||
+	    !section_name ||
+	    !filename_convert)
+		return 1;
+	
+	return 0;
+}
+
+static void bfd_nonfatal(const char *string)
+{
+	const char *errmsg = bfd_errmsg(bfd_get_error());
+
+	if (string)
+		fprintf(stderr, "%s: %s\n", string, errmsg);
+	else
+		fprintf(stderr, "%s\n", errmsg);
+}
+
+static void bfd_fatal(const char *string)
+{
+	bfd_nonfatal(string);
+	_exit(1);
+}
+
+static int file_in_open(char *filename)
+{
+	bfd_in = bfd_openr(filename, "default");
+	if (bfd_in == NULL) {
+		bfd_nonfatal(filename);
+		return 1;
+	}
+
+	if (!bfd_check_format(bfd_in, bfd_object)) {
+		fprintf(stderr, "error: expecting object file\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int file_in_close(void)
+{
+	if (!bfd_close(bfd_in))
+		bfd_fatal(filename_in);
+
+	return 0;
+}
+
+static int file_out_open(void)
+{
+	if (!filename_out) {
+		file_out = stdout;
+		return 0;
+	}
+
+	file_out = fopen(filename_out, "w+");
+	if (!file_out) {
+		perror("fopen failed");
+		return 1;
+	}
+
+	return 0;
+}
+
+static int file_out_close(void)
+{
+	if (file_out)
+		fclose(file_out);
+
+	return 0;
+}
+
+static int get_symbols(void)
+{
+	long storage_needed;
+	long number_of_symbols;
+	long i;
+
+	storage_needed = bfd_get_symtab_upper_bound(bfd_in);
+	if (storage_needed < 0) {
+		bfd_nonfatal("bfd_get_symtab_upper_bound failed");
+		return 1;
+	}
+
+	if (storage_needed == 0) {
+		fprintf(stderr, "no symbols...\n");
+		return 1;
+	}
+
+	symbol_table = malloc(storage_needed);
+	if (!symbol_table) {
+		perror("malloc failed");
+		return 1;
+	}
+
+	number_of_symbols = bfd_canonicalize_symtab(bfd_in, symbol_table);
+	if (number_of_symbols < 0) {
+		bfd_nonfatal("bfd_canonicalize_symtab failed");
+		return 1;
+	}
+
+	PRINT_VERBOSE(1, "got %d symbols\n", number_of_symbols);
+
+	for (i = 0; i < number_of_symbols; i++) {
+
+		const char *section = NULL;
+		struct section_st *ref_sec;
+
+		asymbol *sym = symbol_table[i];
+		flagword sym_flags = sym->flags;
+
+
+		/* no country for weak symbols... */
+		if (sym_flags & BSF_WEAK)
+			continue;
+
+		/* and function club only... */
+		if (!(sym_flags & BSF_FUNCTION))
+			continue;
+
+		if (sym->section)
+			section = symbol_table[i]->section->name;
+
+		ref_sec = section_find(section);
+		if (!ref_sec)
+			continue;
+
+
+		PRINT_VERBOSE(1, "trying func %s %x\n", sym->name, sym->value);
+
+		if (ref_sec->ref_sym) {
+
+			flagword ref_flags   = ref_sec->ref_sym->flags;
+			int current_is_lower = (ref_sec->ref_sym->value < sym->value);
+
+			/* we already have lower global symbol */
+			if ((ref_flags & BSF_GLOBAL) && current_is_lower)
+				continue;
+
+			/* we already have lower local symbol */
+			if ((sym_flags & BSF_LOCAL) && current_is_lower)
+				continue;
+		}
+
+		PRINT_VERBOSE(1, "setting func %s %x\n", sym->name, sym->value);
+		ref_sec->ref_sym = sym;
+	}
+
+	for(i = 0; i < SAFE_SECTIONS_COUNT; i++) {
+		struct section_st *sec = &safe_sections[i];
+
+		PRINT_VERBOSE(1, "%s -> %s\n", sec->name,
+			sec->ref_sym ? sec->ref_sym->name : "undef");
+	}
+
+	return 0;
+}
+
+static void dump_relocs_in_section(bfd *abfd, asection *section, void *dummy)
+{
+	arelent **relpp;
+	long relcount;
+	long relsize;
+	arelent **p;
+	int display_head = 1;
+	struct section_st *sec;
+
+	sec = section_find(section->name);
+	if (!sec)
+		return;
+
+	PRINT_VERBOSE(1, "got %s\n", section->name);
+
+	if (!sec->ref_sym)
+		return;
+
+	relsize = bfd_get_reloc_upper_bound(abfd, section);
+	if (relsize < 0)
+		bfd_fatal("bfd_get_reloc_upper_bound failed");
+
+	if (relsize == 0) {
+		PRINT_VERBOSE(1, "no relocations for section %s\n",
+			      section->name);
+		return;
+	}
+
+	relpp = (arelent **) malloc(relsize);
+	if (!relpp) {
+		perror("malloc failed");
+		return;
+	}
+
+	relcount = bfd_canonicalize_reloc(abfd, section, relpp, symbol_table);
+	if (relcount < 0)
+		bfd_fatal("bfd_canonicalize_reloc failed");
+	else if (relcount == 0)
+		return;
+
+
+	for (p = relpp; relcount && *p != NULL; p++, relcount--) {
+
+		const char *sym_name;
+		arelent *q = *p;
+
+		if (q->sym_ptr_ptr && *q->sym_ptr_ptr) {
+			sym_name = (*(q->sym_ptr_ptr))->name;
+		} else {
+			sym_name = NULL;
+		}
+
+		if (strcmp("mcount", sym_name))
+			continue;
+
+		PRINT_VERBOSE(1, "got mcount reloc %x\n", q->address);
+
+		if (display_head) {
+			if (!file_out && file_out_open())
+				return;
+
+			fprintf(file_out, "\t.section %s,\"a\",%s\n",
+				section_name, section_type);
+
+			if (section_align)
+				fprintf(file_out, "\t.align %s\n", section_align);
+
+			sec->used = 1;
+			display_head = 0;
+		}
+
+		fprintf(file_out, "\t%s %s + %ld\n",
+			data_type, sec->ref_sym->name, 
+			q->address - sec->ref_sym->value);
+        }
+
+	free(relpp);
+}
+
+static int process_relocs(void)
+{
+	bfd_map_over_sections(bfd_in, dump_relocs_in_section, NULL);
+	return 0;
+}
+
+static int process_convert(void)
+{
+	FILE *file_convert = NULL;
+	int i;
+
+	for(i = 0; i < SAFE_SECTIONS_COUNT; i++) {
+		struct section_st *sec = &safe_sections[i];
+		flagword ref_flags;
+
+		if (!sec->used)
+			continue;
+
+		if (!sec->ref_sym) {
+			fprintf(stderr, "section is used and no ref symbol!\n");
+			return 1;
+		}
+
+		ref_flags = sec->ref_sym->flags;
+
+		/* convert only local symbols */
+		if (ref_flags & BSF_GLOBAL)
+			continue;
+
+		if (!file_convert) {
+			file_convert = fopen(filename_convert, "w");
+			if (!file_convert) {
+				perror("fopen failed");
+				return 1;
+			}
+		}
+
+		fprintf(file_convert, "%s ", sec->ref_sym->name);
+	}
+
+	if (file_convert)
+		fclose(file_convert);
+
+	return 0;
+}
+
+int main(int argc, char **argv)
+{
+	int ret = -1;
+
+	if (process_args(argc, argv))
+		usage();
+
+	bfd_init();
+
+	if (filename_out)
+		unlink(filename_out);
+
+	if (file_in_open(filename_in))
+		return 1;
+
+	do {
+		if (get_symbols())
+			break;
+
+		if (process_relocs())
+			break;
+
+		if (process_convert())
+			break;
+
+		ret = 0;
+
+	} while(0);
+
+	file_in_close();
+	file_out_close();
+
+	return ret;
+}
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index f0d1445..05368ac 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -111,53 +111,35 @@ use strict;
 my $P = $0;
 $P =~ s@.*/@@g;
 
-my $V = '0.1';
+my $V = '0.2';
 
-if ($#ARGV != 10) {
-	print "usage: $P arch bits objdump objcopy cc ld nm rm mv is_module inputfile\n";
+if ($#ARGV != 9) {
+	print "usage: $P arch bits mctool objcopy cc ld rm mv is_module inputfile\n";
 	print "version: $V\n";
 	exit(1);
 }
 
-my ($arch, $bits, $objdump, $objcopy, $cc,
-    $ld, $nm, $rm, $mv, $is_module, $inputfile) = @ARGV;
+my ($arch, $bits, $mctool, $objcopy, $cc,
+    $ld, $rm, $mv, $is_module, $inputfile) = @ARGV;
 
 # This file refers to mcount and shouldn't be ftraced, so lets' ignore it
 if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
     exit(0);
 }
 
-# Acceptable sections to record.
-my %text_sections = (
-     ".text" => 1,
-     ".sched.text" => 1,
-     ".spinlock.text" => 1,
-     ".irqentry.text" => 1,
-     ".text.unlikely" => 1,
-);
-
-$objdump = "objdump" if ((length $objdump) == 0);
+# TODO check for valid mctool settings
 $objcopy = "objcopy" if ((length $objcopy) == 0);
 $cc = "gcc" if ((length $cc) == 0);
 $ld = "ld" if ((length $ld) == 0);
-$nm = "nm" if ((length $nm) == 0);
 $rm = "rm" if ((length $rm) == 0);
 $mv = "mv" if ((length $mv) == 0);
 
 #print STDERR "running: $P '$arch' '$objdump' '$objcopy' '$cc' '$ld' " .
 #    "'$nm' '$rm' '$mv' '$inputfile'\n";
 
-my %locals;		# List of local (static) functions
-my %weak;		# List of weak functions
 my %convert;		# List of local functions used that needs conversion
 
 my $type;
-my $local_regex;	# Match a local function (return function)
-my $weak_regex; 	# Match a weak function (return function)
-my $section_regex;	# Find the start of a section
-my $function_regex;	# Find the name of a function
-			#    (return offset and func name)
-my $mcount_regex;	# Find the call site to mcount (return offset)
 my $alignment;		# The .align value to use for $mcount_section
 my $section_type;	# Section header plus possible alignment command
 my $can_use_local = 0; 	# If we can use local function references
@@ -206,22 +188,15 @@ if ($arch eq "x86") {
 # We base the defaults off of i386, the other archs may
 # feel free to change them in the below if statements.
 #
-$local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
-$weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
-$section_regex = "Disassembly of section\\s+(\\S+):";
-$function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
-$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
 $section_type = '@progbits';
 $type = ".long";
 
 if ($arch eq "x86_64") {
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
     $alignment = 8;
 
     # force flags for this arch
     $ld .= " -m elf_x86_64";
-    $objdump .= " -M x86-64";
     $objcopy .= " -O elf64-x86-64";
     $cc .= " -m64";
 
@@ -230,18 +205,15 @@ if ($arch eq "x86_64") {
 
     # force flags for this arch
     $ld .= " -m elf_i386";
-    $objdump .= " -M i386";
     $objcopy .= " -O elf32-i386";
     $cc .= " -m32";
 
 } elsif ($arch eq "s390" && $bits == 32) {
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_32\\s+_mcount\$";
     $alignment = 4;
     $ld .= " -m elf_s390";
     $cc .= " -m31";
 
 } elsif ($arch eq "s390" && $bits == 64) {
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):\\s*R_390_(PC|PLT)32DBL\\s+_mcount\\+0x2\$";
     $alignment = 8;
     $type = ".quad";
     $ld .= " -m elf64_s390";
@@ -256,10 +228,6 @@ if ($arch eq "x86_64") {
     $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
-    $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
-    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\.?.*?)>:";
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s\\.?_mcount\$";
-
     if ($bits == 64) {
 	$type = ".quad";
     }
@@ -269,27 +237,12 @@ if ($arch eq "x86_64") {
     $section_type = '%progbits';
 
 } elsif ($arch eq "ia64") {
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
     $type = "data8";
 
     if ($is_module eq "0") {
         $cc .= " -mconstant-gp";
     }
 } elsif ($arch eq "sparc64") {
-    # In the objdump output there are giblets like:
-    # 0000000000000000 <igmp_net_exit-0x18>:
-    # As there's some data blobs that get emitted into the
-    # text section before the first instructions and the first
-    # real symbols.  We don't want to match that, so to combat
-    # this we use '\w' so we'll match just plain symbol names,
-    # and not those that also include hex offsets inside of the
-    # '<>' brackets.  Actually the generic function_regex setting
-    # could safely use this too.
-    $function_regex = "^([0-9a-fA-F]+)\\s+<(\\w*?)>:";
-
-    # Sparc64 calls '_mcount' instead of plain 'mcount'.
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s_mcount\$";
-
     $alignment = 8;
     $type = ".xword";
     $ld .= " -m elf64_sparc";
@@ -299,9 +252,6 @@ if ($arch eq "x86_64") {
     die "Arch $arch is not supported with CONFIG_FTRACE_MCOUNT_RECORD";
 }
 
-my $text_found = 0;
-my $read_function = 0;
-my $opened = 0;
 my $mcount_section = "__mcount_loc";
 
 my $dirname;
@@ -325,160 +275,26 @@ if ($filename =~ m,^(.*)(\.\S),) {
     $ext = "";
 }
 
-my $mcount_s = $dirname . "/.tmp_mc_" . $prefix . ".s";
-my $mcount_o = $dirname . "/.tmp_mc_" . $prefix . ".o";
+my $mcount_s    = $dirname . "/.tmp_mc_" . $prefix . ".s";
+my $mcount_o    = $dirname . "/.tmp_mc_" . $prefix . ".o";
+my $mcount_conv = $dirname . "/.tmp_mc_" . $prefix . ".conv";
 
 check_objcopy();
 
-#
-# Step 1: find all the local (static functions) and weak symbols.
-#         't' is local, 'w/W' is weak
-#
-open (IN, "$nm $inputfile|") || die "error running $nm";
-while (<IN>) {
-    if (/$local_regex/) {
-	$locals{$1} = 1;
-    } elsif (/$weak_regex/) {
-	$weak{$2} = $1;
-    }
-}
-close(IN);
-
-my @offsets;		# Array of offsets of mcount callers
-my $ref_func;		# reference function to use for offsets
-my $offset = 0;		# offset of ref_func to section beginning
-
-##
-# update_funcs - print out the current mcount callers
-#
-#  Go through the list of offsets to callers and write them to
-#  the output file in a format that can be read by an assembler.
-#
-sub update_funcs
-{
-    return unless ($ref_func and @offsets);
-
-    # Sanity check on weak function. A weak function may be overwritten by
-    # another function of the same name, making all these offsets incorrect.
-    if (defined $weak{$ref_func}) {
-	die "$inputfile: ERROR: referencing weak function" .
-	    " $ref_func for mcount\n";
-    }
-
-    # is this function static? If so, note this fact.
-    if (defined $locals{$ref_func}) {
-
-	# only use locals if objcopy supports globalize-symbols
-	if (!$can_use_local) {
-	    return;
-	}
-	$convert{$ref_func} = 1;
-    }
-
-    # Loop through all the mcount caller offsets and print a reference
-    # to the caller based from the ref_func.
-    for (my $i=0; $i <= $#offsets; $i++) {
-	if (!$opened) {
-	    open(FILE, ">$mcount_s") || die "can't create $mcount_s\n";
-	    $opened = 1;
-	    print FILE "\t.section $mcount_section,\"a\",$section_type\n";
-	    print FILE "\t.align $alignment\n" if (defined($alignment));
-	}
-	printf FILE "\t%s %s + %d\n", $type, $ref_func, $offsets[$i] - $offset;
-    }
-}
-
-#
-# Step 2: find the sections and mcount call sites
-#
-open(IN, "$objdump -hdr $inputfile|") || die "error running $objdump";
-
-my $text;
-
-
-# read headers first
-my $read_headers = 1;
-
-while (<IN>) {
-
-    if ($read_headers && /$mcount_section/) {
-	#
-	# Somehow the make process can execute this script on an
-	# object twice. If it does, we would duplicate the mcount
-	# section and it will cause the function tracer self test
-	# to fail. Check if the mcount section exists, and if it does,
-	# warn and exit.
-	#
-	print STDERR "ERROR: $mcount_section already in $inputfile\n" .
-	    "\tThis may be an indication that your build is corrupted.\n" .
-	    "\tDelete $inputfile and try again. If the same object file\n" .
-	    "\tstill causes an issue, then disable CONFIG_DYNAMIC_FTRACE.\n";
-	exit(-1);
-    }
-
-    # is it a section?
-    if (/$section_regex/) {
-	$read_headers = 0;
-
-	# Only record text sections that we know are safe
-	if (defined($text_sections{$1})) {
-	    $read_function = 1;
-	} else {
-	    $read_function = 0;
-	}
-	# print out any recorded offsets
-	update_funcs();
-
-	# reset all markers and arrays
-	$text_found = 0;
-	undef($ref_func);
-	undef(@offsets);
-
-    # section found, now is this a start of a function?
-    } elsif ($read_function && /$function_regex/) {
-	$text_found = 1;
-	$text = $2;
-
-	# if this is either a local function or a weak function
-	# keep looking for functions that are global that
-	# we can use safely.
-	if (!defined($locals{$text}) && !defined($weak{$text})) {
-	    $ref_func = $text;
-	    $read_function = 0;
-	    $offset = hex $1;
-	} else {
-	    # if we already have a function, and this is weak, skip it
-	    if (!defined($ref_func) && !defined($weak{$text}) &&
-		 # PPC64 can have symbols that start with .L and
-		 # gcc considers these special. Don't use them!
-		 $text !~ /^\.L/) {
-		$ref_func = $text;
-		$offset = hex $1;
-	    }
-	}
-    }
-    # is this a call site to mcount? If so, record it to print later
-    if ($text_found && /$mcount_regex/) {
-	$offsets[$#offsets + 1] = hex $1;
-    }
-}
-
-# dump out anymore offsets that may have been found
-update_funcs();
+`$mctool -T "$section_type" -a "$alignment" -t "$type" -c "$mcount_conv" -o "$mcount_s" -n "$mcount_section" $inputfile`;
 
 # If we did not find any mcount callers, we are done (do nothing).
-if (!$opened) {
-    exit(0);
+if (!stat("$mcount_s")) {
+	exit(0);
 }
 
-close(FILE);
-
 #
 # Step 3: Compile the file that holds the list of call sites to mcount.
 #
 `$cc -o $mcount_o -c $mcount_s`;
 
-my @converts = keys %convert;
+my $convert = `touch $mcount_conv; cat "$mcount_conv"`;
+my @converts = split(/ /, $convert);
 
 #
 # Step 4: Do we have sections that started with local functions?
