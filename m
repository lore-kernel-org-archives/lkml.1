Return-Path: <linux-kernel-owner+w=401wt.eu-S1760805AbXGTL6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760805AbXGTL6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 07:58:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754485AbXGTL6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 07:58:04 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:55906 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbXGTL6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 07:58:03 -0400
Date: Fri, 20 Jul 2007 13:58:13 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kay.sievers@vrfy.org
Subject: Re: kobject link failure
Message-ID: <20070720135813.0e416b2b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070720113221.390ed32a@gondolin.boeblingen.de.ibm.com>
References: <Pine.LNX.4.64.0707191956510.31013@fbirervta.pbzchgretzou.qr>
	<469FA94E.20002@googlemail.com>
	<20070720080059.GA29639@suse.de>
	<20070720113221.390ed32a@gondolin.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Jul 2007 11:32:21 +0200,
Cornelia Huck <cornelia.huck@de.ibm.com> wrote:

> Hm, this would be an interface change (the uevent attribute used to
> exist even for !CONFIG_HOTPLUG, it just triggered nothing). How about
> moving kobject_actions[] out of the #ifdef (maybe next to
> kobject_action)?

Leaving kobject_actions[] in kobject_uevent.c, but putting it outside
the #ifdef looks indeed like the best solution to me. This way, we
avoid adding #ifdef CONFIG_HOTPLUG into core.c, when all other
functions called do not need such a thing.


Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>

---
 lib/kobject_uevent.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- linux-2.6.orig/lib/kobject_uevent.c
+++ linux-2.6/lib/kobject_uevent.c
@@ -25,14 +25,6 @@
 #define BUFFER_SIZE	2048	/* buffer for the variables */
 #define NUM_ENVP	32	/* number of env pointers */
 
-#if defined(CONFIG_HOTPLUG)
-u64 uevent_seqnum;
-char uevent_helper[UEVENT_HELPER_PATH_LEN] = "/sbin/hotplug";
-static DEFINE_SPINLOCK(sequence_lock);
-#if defined(CONFIG_NET)
-static struct sock *uevent_sock;
-#endif
-
 /* the strings here must match the enum in include/linux/kobject.h */
 const char *kobject_actions[] = {
 	"add",
@@ -43,6 +35,14 @@ const char *kobject_actions[] = {
 	"offline",
 };
 
+#if defined(CONFIG_HOTPLUG)
+u64 uevent_seqnum;
+char uevent_helper[UEVENT_HELPER_PATH_LEN] = "/sbin/hotplug";
+static DEFINE_SPINLOCK(sequence_lock);
+#if defined(CONFIG_NET)
+static struct sock *uevent_sock;
+#endif
+
 /**
  * kobject_uevent_env - send an uevent with environmental data
  *
