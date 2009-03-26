Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbZCZVrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbZCZVrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbZCZVro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:47:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59434 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754190AbZCZVro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:47:44 -0400
Date: Thu, 26 Mar 2009 22:50:31 +0100
From: Pavel Machek <pavel@ucw.cz>
To: James Morris <jmorris@namei.org>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: TOMOYO in linux-next
Message-ID: <20090326215031.GD29836@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I don't think merging that is good idea. Security should be doable
without making shell-like glob matching...

+/**
+ * tomoyo_file_matches_to_pattern2 - Pattern matching without '/' character
+ * and "\-" pattern.
+ *
+ * @filename:     The start of string to check.
+ * @filename_end: The end of string to check.
+ * @pattern:      The start of pattern to compare.
+ * @pattern_end:  The end of pattern to compare.
+ *
+ * Returns true if @filename matches @pattern, false otherwise.
+ */
+static bool tomoyo_file_matches_to_pattern2(const char *filename,


...or code like...

+/**
+ * tomoyo_path_depth - Evaluate the number of '/' in a string.
+ *
+ * @pathname: The string to evaluate.
+ *
+ * Returns path depth of the string.
+ *
+ * I score 2 for each of the '/' in the @pathname
+ * and score 1 if the @pathname ends with '/'.
+ */
+static int tomoyo_path_depth(const char *pathname)

...or code like...

+/* String table for functionality that takes 2 modes. */
+static const char *tomoyo_mode_2[4] = {
+       "disabled", "enabled", "enabled", "enabled"
+};

Are those interfaces documented somewhere?

This is quite nasty. I don't think turning off enforcement in
interrupt is good idea. ("fails open").


+/**
+ * tomoyo_check_flags - Check mode for specified functionality.
+ *
+ * @domain: Pointer to "struct tomoyo_domain_info".
+ * @index:  The functionality to check mode.
+ *
+ * TOMOYO checks only process context.
+ * This code disables TOMOYO's enforcement in case the function is
called from
+ * interrupt context.
+ */
+unsigned int tomoyo_check_flags(const struct tomoyo_domain_info
*domain,
+                               const u8 index)
+{
+       const u8 profile = domain->profile;
+
+       if (WARN_ON(in_interrupt()))
+               return 0;

Comments leave something to be desired:

+       /***** EXCLUSIVE SECTION START *****/

+/**
+ * tomoyo_close_control - close() for /sys/kernel/security/tomoyo/
interface.
+ *
+ * @file: Pointer to "struct file".


I'm not sure basing security on pids is good idea...

+       /* Don't allow updating policies by non manager programs. */
+       if (head->write != tomoyo_write_pid &&

Hmm, barrier is spelled otherwise, and I'm not sure I'd trust this:

+struct tomoyo_path_info_with_data {
+       /* Keep "head" first, for this pointer is passed to tomoyo_free(). */
+       struct tomoyo_path_info head;
+       char bariier1[16]; /* Safeguard for overrun. */

I guess constants should be used here:

+#ifdef TOMOYO_DEBUG_DOMAIN_UNDELETE
+                       if (domain2->is_deleted != 255)
+                               printk(KERN_DEBUG
+                                      "Marked %p as non undeletable\n",
+                                      domain2);
+#endif
+                       domain2->is_deleted = 255;

(I don't know why we want undelete in tomoyo.)

If it contains copyright, it should contain copyright. It probably
should not contain version numbers.

+/*
+ * security/tomoyo/file.c
+ *
+ * Implementation of the Domain-Based Mandatory Access Control.
+ *
+ * Copyright (C) 2005-2009  NTT DATA CORPORATION
+ *
+ * Version: 2.2.0-pre   2009/02/01

Code is full of tables such as:

+/* Keyword array for single path operations. */
+static const char
*tomoyo_sp_keyword[TOMOYO_MAX_SINGLE_PATH_OPERATION] = {
+       [TOMOYO_TYPE_READ_WRITE_ACL] = "read/write",
+       [TOMOYO_TYPE_EXECUTE_ACL]    = "execute",
+       [TOMOYO_TYPE_READ_ACL]       = "read",
+       [TOMOYO_TYPE_WRITE_ACL]      = "write",
+       [TOMOYO_TYPE_CREATE_ACL]     = "create",
+       [TOMOYO_TYPE_UNLINK_ACL]     = "unlink",
+       [TOMOYO_TYPE_MKDIR_ACL]      = "mkdir",
+       [TOMOYO_TYPE_RMDIR_ACL]      = "rmdir",
+       [TOMOYO_TYPE_MKFIFO_ACL]     = "mkfifo",
+       [TOMOYO_TYPE_MKSOCK_ACL]     = "mksock",
+       [TOMOYO_TYPE_MKBLOCK_ACL]    = "mkblock",
+       [TOMOYO_TYPE_MKCHAR_ACL]     = "mkchar",
+       [TOMOYO_TYPE_TRUNCATE_ACL]   = "truncate",
+       [TOMOYO_TYPE_SYMLINK_ACL]    = "symlink",
+       [TOMOYO_TYPE_REWRITE_ACL]    = "rewrite",
+};

Can we get an interface that does not need as many strings/ as much
string parsing?

That's my main complaint: Documentation.*tomoyo nor
Documentation.*TOMOYO does not exist, still this adds a *lot* of new
user<->kernel interfaces.

New user<->kernel interaces should be documented and very carefuly
reviewed; I don't think that happened here.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
