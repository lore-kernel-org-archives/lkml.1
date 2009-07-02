Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZGBGHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZGBGHX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGBGHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:07:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:56861 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751425AbZGBGHL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:07:11 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX197oHNA+rZ7FLKaeyQnTvJKDTauTPWaRjP90kQYpT
	oBFw4GJRJjCNmy
Subject: [patch 2/4] perf_counter tools:  Add infrastructure to support
 loading of kernel module symbols
From: Mike Galbraith <efault@gmx.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <1246514639.13293.40.camel@marge.simson.net>
References: <1246514639.13293.40.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 02 Jul 2009 08:07:10 +0200
Message-Id: <1246514830.13293.44.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf_counter tools:  Add infrastructure to support loading of kernel module symbols.

Add infrastructure for module path discovery and section load addresses.

Signed-off-by: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>

---
 tools/perf/Makefile      |    2 
 tools/perf/util/module.c |  502 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/module.h |   53 ++++
 3 files changed, 557 insertions(+)

Index: linux-2.6/tools/perf/Makefile
===================================================================
--- linux-2.6.orig/tools/perf/Makefile
+++ linux-2.6/tools/perf/Makefile
@@ -306,6 +306,7 @@ LIB_H += util/strlist.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
+LIB_H += util/module.h
 LIB_H += util/color.h
 
 LIB_OBJS += util/abspath.o
@@ -329,6 +330,7 @@ LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
 LIB_OBJS += util/sigchain.o
 LIB_OBJS += util/symbol.o
+LIB_OBJS += util/module.o
 LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
 LIB_OBJS += util/header.o
Index: linux-2.6/tools/perf/util/module.h
===================================================================
--- /dev/null
+++ linux-2.6/tools/perf/util/module.h
@@ -0,0 +1,53 @@
+#ifndef _PERF_MODULE_
+#define _PERF_MODULE_ 1
+
+#include <linux/types.h>
+#include "../types.h"
+#include <linux/list.h>
+#include <linux/rbtree.h>
+
+struct section {
+	struct rb_node	rb_node;
+	u64		hash;
+	u64		vma;
+	char		*name;
+	char		*path;
+};
+
+struct sec_dso {
+	struct list_head node;
+	struct rb_root	 secs;
+	struct section    *(*find_section)(struct sec_dso *, const char *name);
+	char		 name[0];
+};
+
+struct module {
+	struct rb_node	rb_node;
+	u64		hash;
+	char		*name;
+	char		*path;
+	struct sec_dso	*sections;
+	int		active;
+};
+
+struct mod_dso {
+	struct list_head node;
+	struct rb_root	 mods;
+	struct module    *(*find_module)(struct mod_dso *, const char *name);
+	char		 name[0];
+};
+
+struct sec_dso *sec_dso__new_dso(const char *name);
+void sec_dso__delete_sections(struct sec_dso *self);
+void sec_dso__delete_self(struct sec_dso *self);
+size_t sec_dso__fprintf(struct sec_dso *self, FILE *fp);
+struct section *sec_dso__find_section(struct sec_dso *self, const char *name);
+
+struct mod_dso *mod_dso__new_dso(const char *name);
+void mod_dso__delete_modules(struct mod_dso *self);
+void mod_dso__delete_self(struct mod_dso *self);
+size_t mod_dso__fprintf(struct mod_dso *self, FILE *fp);
+struct module *mod_dso__find_module(struct mod_dso *self, const char *name);
+int mod_dso__load_modules(struct mod_dso *dso);
+
+#endif /* _PERF_MODULE_ */
Index: linux-2.6/tools/perf/util/module.c
===================================================================
--- /dev/null
+++ linux-2.6/tools/perf/util/module.c
@@ -0,0 +1,502 @@
+#include "util.h"
+#include "../perf.h"
+#include "string.h"
+#include "module.h"
+
+#include <libelf.h>
+#include <gelf.h>
+#include <elf.h>
+#include <dirent.h>
+#include <sys/utsname.h>
+
+static unsigned int crc32(const char *p, unsigned int len)
+{
+	int i;
+	unsigned int crc = 0;
+	while (len--) {
+		crc ^= *p++;
+		for (i = 0; i < 8; i++)
+			crc = (crc >> 1) ^ ((crc & 1) ? 0xedb88320 : 0);
+	}
+	return crc;
+}
+
+/* module section methods */
+
+struct sec_dso *sec_dso__new_dso(const char *name)
+{
+	struct sec_dso *self = malloc(sizeof(*self) + strlen(name) + 1);
+
+	if (self != NULL) {
+		strcpy(self->name, name);
+		self->secs = RB_ROOT;
+		self->find_section = sec_dso__find_section;
+	}
+
+	return self;
+}
+
+static void sec_dso__delete_section(struct section *self)
+{
+	free(((void *)self));
+}
+
+void sec_dso__delete_sections(struct sec_dso *self)
+{
+	struct section *pos;
+	struct rb_node *next = rb_first(&self->secs);
+
+	while (next) {
+		pos = rb_entry(next, struct section, rb_node);
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, &self->secs);
+		sec_dso__delete_section(pos);
+	}
+}
+
+void sec_dso__delete_self(struct sec_dso *self)
+{
+	sec_dso__delete_sections(self);
+	free(self);
+}
+
+static void sec_dso__insert_section(struct sec_dso *self, struct section *sec)
+{
+	struct rb_node **p = &self->secs.rb_node;
+	struct rb_node *parent = NULL;
+	const u64 hash = sec->hash;
+	struct section *s;
+
+	while (*p != NULL) {
+		parent = *p;
+		s = rb_entry(parent, struct section, rb_node);
+		if (hash < s->hash)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&sec->rb_node, parent, p);
+	rb_insert_color(&sec->rb_node, &self->secs);
+}
+
+struct section *sec_dso__find_section(struct sec_dso *self, const char *name)
+{
+	struct rb_node *n;
+	u64 hash;
+	int len;
+
+	if (self == NULL)
+		return NULL;
+
+	len = strlen(name);
+	hash = crc32(name, len);
+
+	n = self->secs.rb_node;
+
+	while (n) {
+		struct section *s = rb_entry(n, struct section, rb_node);
+
+		if (hash < s->hash)
+			n = n->rb_left;
+		else if (hash > s->hash)
+			n = n->rb_right;
+		else {
+			if (!strcmp(name, s->name))
+				return s;
+			else
+				n = rb_next(&s->rb_node);
+		}
+	}
+
+	return NULL;
+}
+
+static size_t sec_dso__fprintf_section(struct section *self, FILE *fp)
+{
+	return fprintf(fp, "name:%s vma:%llx path:%s\n",
+		       self->name, self->vma, self->path);
+}
+
+size_t sec_dso__fprintf(struct sec_dso *self, FILE *fp)
+{
+	size_t ret = fprintf(fp, "dso: %s\n", self->name);
+
+	struct rb_node *nd;
+	for (nd = rb_first(&self->secs); nd; nd = rb_next(nd)) {
+		struct section *pos = rb_entry(nd, struct section, rb_node);
+		ret += sec_dso__fprintf_section(pos, fp);
+	}
+
+	return ret;
+}
+
+static struct section *section__new(const char *name, const char *path)
+{
+	struct section *self = calloc(1, sizeof(*self));
+
+	if (!self)
+		goto out_failure;
+
+	self->name = calloc(1, strlen(name) + 1);
+	if (!self->name)
+		goto out_failure;
+
+	self->path = calloc(1, strlen(path) + 1);
+	if (!self->path)
+		goto out_failure;
+
+	strcpy(self->name, name);
+	strcpy(self->path, path);
+	self->hash = crc32(self->name, strlen(name));
+
+	return self;
+
+out_failure:
+	if (self) {
+		if (self->name)
+			free (self->name);
+		if (self->path)
+			free (self->path);
+		free (self);
+	}
+
+	return NULL;
+}
+
+/* module methods */
+
+struct mod_dso *mod_dso__new_dso(const char *name)
+{
+	struct mod_dso *self = malloc(sizeof(*self) + strlen(name) + 1);
+
+	if (self != NULL) {
+		strcpy(self->name, name);
+		self->mods = RB_ROOT;
+		self->find_module = mod_dso__find_module;
+	}
+
+	return self;
+}
+
+static void mod_dso__delete_module(struct module *self)
+{
+	free(((void *)self));
+}
+
+void mod_dso__delete_modules(struct mod_dso *self)
+{
+	struct module *pos;
+	struct rb_node *next = rb_first(&self->mods);
+
+	while (next) {
+		pos = rb_entry(next, struct module, rb_node);
+		next = rb_next(&pos->rb_node);
+		rb_erase(&pos->rb_node, &self->mods);
+		mod_dso__delete_module(pos);
+	}
+}
+
+void mod_dso__delete_self(struct mod_dso *self)
+{
+	mod_dso__delete_modules(self);
+	free(self);
+}
+
+static void mod_dso__insert_module(struct mod_dso *self, struct module *mod)
+{
+	struct rb_node **p = &self->mods.rb_node;
+	struct rb_node *parent = NULL;
+	const u64 hash = mod->hash;
+	struct module *m;
+
+	while (*p != NULL) {
+		parent = *p;
+		m = rb_entry(parent, struct module, rb_node);
+		if (hash < m->hash)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+	rb_link_node(&mod->rb_node, parent, p);
+	rb_insert_color(&mod->rb_node, &self->mods);
+}
+
+struct module *mod_dso__find_module(struct mod_dso *self, const char *name)
+{
+	struct rb_node *n;
+	u64 hash;
+	int len;
+
+	if (self == NULL)
+		return NULL;
+
+	len = strlen(name);
+	hash = crc32(name, len);
+
+	n = self->mods.rb_node;
+
+	while (n) {
+		struct module *m = rb_entry(n, struct module, rb_node);
+
+		if (hash < m->hash)
+			n = n->rb_left;
+		else if (hash > m->hash)
+			n = n->rb_right;
+		else {
+			if (!strcmp(name, m->name))
+				return m;
+			else
+				n = rb_next(&m->rb_node);
+		}
+	}
+
+	return NULL;
+}
+
+static size_t mod_dso__fprintf_module(struct module *self, FILE *fp)
+{
+	return fprintf(fp, "name:%s path:%s\n", self->name, self->path);
+}
+
+size_t mod_dso__fprintf(struct mod_dso *self, FILE *fp)
+{
+	size_t ret = fprintf(fp, "dso: %s\n", self->name);
+
+	struct rb_node *nd;
+	for (nd = rb_first(&self->mods); nd; nd = rb_next(nd)) {
+		struct module *pos = rb_entry(nd, struct module, rb_node);
+		ret += mod_dso__fprintf_module(pos, fp);
+	}
+
+	return ret;
+}
+
+static struct module *module__new(const char *name, const char *path)
+{
+	struct module *self = calloc(1, sizeof(*self));
+
+	if (!self)
+		goto out_failure;
+
+	self->name = calloc(1, strlen(name) + 1);
+	if (!self->name)
+		goto out_failure;
+
+	self->path = calloc(1, strlen(path) + 1);
+	if (!self->path)
+		goto out_failure;
+
+	strcpy(self->name, name);
+	strcpy(self->path, path);
+	self->hash = crc32(self->name, strlen(name));
+
+	return self;
+
+out_failure:
+	if (self) {
+		if (self->name)
+			free (self->name);
+		if (self->path)
+			free (self->path);
+		free (self);
+	}
+
+	return NULL;
+}
+
+static int mod_dso__load_sections(struct module *mod)
+{
+	struct dirent *entry;
+	DIR *dir;
+	size_t n;
+	int count = 0, path_len;
+	char *line = NULL;
+	char *dir_path;
+
+	path_len = strlen("/sys/module/");
+	path_len += strlen(mod->name);
+	path_len += strlen("/sections/");
+
+	dir_path = calloc(1, path_len + 1);
+	if (dir_path == NULL)
+		goto out_failure;
+
+	strcat(dir_path, "/sys/module/");
+	strcat(dir_path, mod->name);
+	strcat(dir_path, "/sections/");
+
+	dir = opendir(dir_path);
+	if (dir == NULL)
+		goto out_free;
+
+	while ((entry = readdir(dir))) {
+		struct section *section;
+		FILE *file;
+		char *path, *vma;
+		int line_len;
+
+		if (!strcmp(".", entry->d_name) || !strcmp("..", entry->d_name))
+			continue;
+
+		path = calloc(1, path_len + strlen(entry->d_name) + 1);
+		if (path == NULL)
+			break;
+		strcat(path, dir_path);
+		strcat(path, entry->d_name);
+
+		file = fopen(path, "r");
+		if (file == NULL) {
+			free(path);
+			break;
+		}
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0) {
+			free(path);
+			fclose(file);
+			break;
+		}
+
+		if (!line) {
+			free(path);
+			fclose(file);
+			break;
+		}
+
+		line[--line_len] = '\0'; /* \n */
+
+                vma = strstr(line, "0x");
+                if (!vma) {
+			free(path);
+			fclose(file);
+                        break;
+		}
+                vma += 2;
+
+		section = section__new(entry->d_name, path);
+		if (!section) {
+			fprintf(stderr, "load_sections: allocation error\n");
+			free(path);
+			fclose(file);
+			break;
+		}
+
+		hex2u64(vma, &section->vma);
+		sec_dso__insert_section(mod->sections, section);
+
+		free(path);
+		fclose(file);
+		count++;
+	}
+
+	closedir(dir);
+	free(line);
+	free(dir_path);
+
+	return count;
+
+out_free:
+	free(dir_path);
+
+out_failure:
+	return count;
+}
+
+static int mod_dso__load_module_paths(struct mod_dso *self)
+{
+	struct utsname uts;
+	char *line = NULL;
+	size_t n;
+	FILE *file;
+	int count = 0, len;
+	char *path;
+
+	if(uname(&uts) < 0)
+		goto out_failure;
+
+	len = strlen("/lib/modules/");
+	len += strlen(uts.release);
+	len += strlen("/modules.dep");
+
+	path = calloc(1, len);
+	if (path == NULL)
+		goto out_failure;
+
+	strcat(path, "/lib/modules/");
+	strcat(path, uts.release);
+	strcat(path, "/modules.dep");
+
+	file = fopen(path, "r");
+	free(path);
+	if (file == NULL)
+		goto out_failure;
+
+	while (!feof(file)) {
+		struct module *module;
+		int line_len, len;
+		char *path, *name, *tmp;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0)
+			break;
+
+		if (!line)
+			goto out_failure;
+
+		line[--line_len] = '\0'; /* \n */
+
+		path = strtok(line, ":");
+		if (!path)
+			goto out_failure;
+
+		name = strdup(path);
+		name = tmp = strtok(name, "/");
+		while(tmp) {
+			tmp = strtok(NULL, "/");
+			if (tmp)
+				name = tmp;
+		}
+		name = strsep(&name, ".");
+
+		/* Replace '-' with '_' in damn sound modules */
+		for (len = strlen(name); len; len--)
+			if (*(name+len) == '-')
+				*(name+len) = '_';
+
+		module = module__new(name, path);
+		if (!module) {
+			fprintf(stderr, "load_module_paths: allocation error\n");
+			goto out_failure;
+		}
+		mod_dso__insert_module(self, module);
+
+		module->sections = sec_dso__new_dso("sections");
+		if (!module->sections) {
+			fprintf(stderr, "load_module_paths: allocation error\n");
+			goto out_failure;
+		}
+
+		module->active = mod_dso__load_sections(module);
+
+		if (module->active > 0)
+			count++;
+	}
+
+	free(line);
+	fclose(file);
+
+	return count;
+
+out_failure:
+	return -1;
+}
+
+int mod_dso__load_modules(struct mod_dso *dso)
+{
+	int err;
+
+	err = mod_dso__load_module_paths(dso);
+
+	return err;
+}
+


