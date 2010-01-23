Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300Ab0AWMxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab0AWMxy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 07:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755155Ab0AWMxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 07:53:53 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:50528 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab0AWMxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 07:53:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=f9AuNOBW9gRVX4fuAFy26sYxCwnwkdyxVPStWfmEsuD35SdHSz+1GZibmTiNrXj6Fh
         lsV7byYqCnzrQwjX503zolGX2gMgu0lZ5zxBYsZevXNF0eOJbJVY1/w22G55epfAcDoO
         HkJ5AfhbqCf2m+rvod7udwlEgYOg/NNU8C7eQ=
MIME-Version: 1.0
In-Reply-To: <20100121230331.GA29796@kroah.com>
References: <20100120171901.b2e06465.sfr@canb.auug.org.au>
	 <b9df5fa11001202022q22c2d81cs5b90f694be37c1f4@mail.gmail.com>
	 <20100121230331.GA29796@kroah.com>
Date: Sat, 23 Jan 2010 18:53:51 +0600
Message-ID: <b9df5fa11001230453k4a874ebamff02b64f7d6fcd84@mail.gmail.com>
Subject: Re: linux-next: tty tree build warning
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Michael H. Warfield" <mhw@wittsend.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/22/10, Greg KH <greg@kroah.com> wrote:
> On Thu, Jan 21, 2010 at 10:22:19AM +0600, Rakib Mullick wrote:
>  > On 1/20/10, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> That sounds right.  Care to send a patch?
>
Please - checkout the following one - is it okay or not. Notice if it
requires any adjustment.

 Patch is created using 2.6.33-rc5. Needs to apply the patch
named 'ip2-remove-ifdef-module-from-ip2main.c.patch'
(http://lkml.org/lkml/2009/12/1/90)
currently in gregkh-2.6 tree to compile cleanly.

---

 char,ip2: Add module parameter.

Stephen Rothwell found the following warning (x86_64 allmodconfig):

drivers/char/ip2/ip2main.c:511: warning: 'ip2_setup' defined but not used

This patch adds module parameter to fix the above warning.


Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

--- linus/drivers/char/ip2/ip2main.c	2010-01-16 13:36:44.000000000 +0600
+++ rakib/drivers/char/ip2/ip2main.c	2010-01-23 11:23:55.000000000 +0600
@@ -208,6 +208,7 @@ static int DumpFifoBuffer( char __user *

 static void ip2_init_board(int, const struct firmware *);
 static unsigned short find_eisa_board(int);
+static int ip2_setup(char *str);

 /***************/
 /* Static Data */
@@ -285,7 +286,10 @@ MODULE_AUTHOR("Doug McNash");
 MODULE_DESCRIPTION("Computone IntelliPort Plus Driver");
 MODULE_LICENSE("GPL");

+#define	MAX_CMD_STR	50
+
 static int poll_only;
+static char cmd[MAX_CMD_STR];

 static int Eisa_irq;
 static int Eisa_slot;
@@ -309,6 +313,8 @@ module_param_array(io, int, NULL, 0);
 MODULE_PARM_DESC(io, "I/O ports for IntelliPort Cards");
 module_param(poll_only, bool, 0);
 MODULE_PARM_DESC(poll_only, "Do not use card interrupts");
+module_param_string(ip2, cmd, MAX_CMD_STR, 0);
+MODULE_PARM_DESC(ip2, "Contains module parameter passed with 'ip2='");

 /* for sysfs class support */
 static struct class *ip2_class;
@@ -541,12 +547,19 @@ static int __init ip2_loadmain(void)
 	int rc = -1;
 	struct pci_dev *pdev = NULL;
 	const struct firmware *fw = NULL;
+	char *str;
+
+	str = cmd;

 	if (poll_only) {
 		/* Hard lock the interrupts to zero */
 		irq[0] = irq[1] = irq[2] = irq[3] = poll_only = 0;
 	}

+	/* Check module parameter with 'ip2=' has been passed or not */
+	if (!poll_only && (!strncmp(str, "ip2=", 4)))
+		ip2_setup(str);
+
 	ip2trace(ITRC_NO_PORT, ITRC_INIT, ITRC_ENTER, 0);

 	/* process command line arguments to modprobe or
