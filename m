Return-Path: <linux-kernel-owner+w=401wt.eu-S1761440AbXJLRJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761440AbXJLRJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 13:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbXJLRI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 13:08:57 -0400
Received: from gw.goop.org ([64.81.55.164]:34904 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932791AbXJLRIz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 13:08:55 -0400
Message-ID: <470FAA21.6040105@goop.org>
Date: Fri, 12 Oct 2007 10:08:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: David Chinner <dgc@sgi.com>
CC: xfs@oss.sgi.com, Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mark Williamson <mark.williamson@cl.cam.ac.uk>,
       =?UTF-8?B?TW9ydGVuIELDuGc=?= =?UTF-8?B?ZXNrb3Y=?= 
	<xen-users@morten.bogeskov.dk>,
       xfs-masters@oss.sgi.com
Subject: Re: Interaction between Xen and XFS: stray RW mappings
References: <470FA7C3.90404@goop.org>
In-Reply-To: <470FA7C3.90404@goop.org>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> I guess we could create a special-case interface to do the same thing
> with XFS mappings, but it would be nicer to have something more generic.
>
> Is my analysis correct?  Or should XFS not be holding stray mappings? 
> Or is there already some kind of generic mechanism I can use to get it
> to release its mappings?

This test patch confirms my theory:

diff -r 36a518c1fb4b fs/xfs/linux-2.6/xfs_buf.c
--- a/fs/xfs/linux-2.6/xfs_buf.c	Fri Oct 12 10:03:56 2007 -0700
+++ b/fs/xfs/linux-2.6/xfs_buf.c	Fri Oct 12 10:07:03 2007 -0700
@@ -186,6 +186,11 @@ free_address(
 	void		*addr)
 {
 	a_list_t	*aentry;
+
+#ifdef CONFIG_XEN
+	vunmap(addr);
+	return;
+#endif
 
 	aentry = kmalloc(sizeof(a_list_t), GFP_NOWAIT);
 	if (likely(aentry)) {


With this in place, the problem goes away.

    J
