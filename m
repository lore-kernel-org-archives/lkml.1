Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbZGLV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbZGLV5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbZGLV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 17:57:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470AbZGLV5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 17:57:11 -0400
Subject: Re: 2.6.31-rc2: BUG: unable to handle kernel NULL pointer
 dereference
From: Eric Paris <eparis@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org,
       thomas@m3y3r.de, sds@tycho.nsa.gov, jmorris@namei.org,
       eparis@parisplace.org
In-Reply-To: <4A5A46ED.7010907@gmail.com>
References: <1247410030.1095.1.camel@localhost>
	 <loom.20090712T172408-520@post.gmane.org>  <4A5A46ED.7010907@gmail.com>
Content-Type: text/plain
Date: Sun, 12 Jul 2009 17:56:10 -0400
Message-Id: <1247435770.3068.7.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-07-12 at 22:26 +0200, Jiri Slaby wrote:
> On 07/12/2009 07:30 PM, Parag Warudkar wrote:
> > static void selinux_write_opts(struct seq_file *m,
> > 1012                                struct security_mnt_opts *opts)
> > 1013 {
> > 1014         int i;
> > 1015         char *prefix;
> > 1016
> > 1017         for (i = 0; i < opts->num_mnt_opts; i++) {
> > 1018                 char *has_comma;
> > 1019
> > 1020                 if (opts->mnt_opts[i])
> > 1021                         has_comma = strchr(opts->mnt_opts[i], ',');
> >                                          ^^^^^^^^^^^^^^^^^^^^^^^^^
> > And that is a NULL pointer dereference - but we just checked for
> > opts->mnt_opts[i] for not NULL. 
> 
> Note, that there is not a NULL dereference. It dereferences 0x40 which
> came in as %rdi. Looks like somebody assigned garbage in there.
> 
> Or a single bit mem error. Is memtest OK with this machine?
> 
> What warning tainted the kernel before this oops is still interesting...

I just looked over the selinux code where we build the
security_mnt_opts. We can do a 0 length kmalloc, but that should hurt
aything.  I should probably not be doing any allocations and leaving the
opts->mnt_opts and opts->mnt_opts_flags == NULL, but 0x40 !=
ZERO_SIZE_PTR(0x10) nor is the security_mnt_opts structure anywhere near
large enough to hit an offset of 0x40.....

I really think I'd like to see any previous BUG/WARN messages you got
and like Jiri said, see if memtest86+ runs cleanly....

-Eric

