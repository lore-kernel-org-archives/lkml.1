Return-Path: <linux-kernel-owner+w=401wt.eu-S1758982AbYAHKs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982AbYAHKs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:48:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbYAHKpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:45:24 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:42092 "EHLO
	e28esmtp04.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754608AbYAHKpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:45:22 -0500
Date: Tue, 8 Jan 2008 16:14:53 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, kamalesh@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, bunk@kernel.org, apw@shadowen.org,
       balbir@linux.vnet.ibm.com
Subject: Re: Linux 2.6.24-rc7 Build-Failure at __you_cannot_kmalloc_that_much
Message-ID: <20080108104453.GA20386@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <alpine.LFD.1.00.0801061410290.3148@woody.linux-foundation.org> <478200A4.4090707@linux.vnet.ibm.com> <20080107100733.3655f74f.akpm@linux-foundation.org> <Pine.LNX.4.64.0801071014450.22642@schroedinger.engr.sgi.com> <20080107113831.0865cf5e.akpm@linux-foundation.org> <20080108105609.197a2874@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080108105609.197a2874@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2008 at 10:56:09AM +0100, Jean Delvare wrote:
> Hi Andrew, hi Chritoph,
> 
> On Mon, 7 Jan 2008 11:38:31 -0800, Andrew Morton wrote:
> > On Mon, 7 Jan 2008 10:31:53 -0800 (PST)
> > Christoph Lameter <clameter@sgi.com> wrote:
> > 
> > > On Mon, 7 Jan 2008, Andrew Morton wrote:
> > > 
> > > > > : undefined reference to `__you_cannot_kmalloc_that_much'
> > > 
> > > There is also a kernel.org bugzilla for this at
> > > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9669
> > > For some reason my adds to this do not show up.
> > > 
> > > In both cases we have a 
> > > 
> > > k(z/m)alloc(sizeof(*pointer), ...)
> > > 
> > > that is for some reason failing. I guess what happens is that the function 
> > > in which this occurs is too complex for gcc 3.2. Thus it stops constant 
> > > folding the sizeof(*pointer) in the complex inline-if-cascade that SLAB 
> > > needs to determine the cache and does not eliminate the 
> > > __you_cannot_kmalloc_that_much branch().
> 
> Interesting theory... So I tried to split half of the code of
> dmi_id_init() to a subfunction and bingo! gcc 3.2.3 is now able to
> build it properly. Thanks for the hint!
> 
> > > SLUB in that case just puts a series of if comparisions in the code. This 
> > > means compilation does not fail but a large amount of code is generated.
> > 
> > ug.  Silent and nasty.
> > 
> > > We could replace the __you_cannot_kmalloc_that_much() with a BUG() 
> > > statement so we have the same effect in SLAB?
> > 
> > I think it'd be better to just put suitable workarounds at the offending
> > callsites.  We've only seen three or four of them in several months.
> 
> Here's a workaround for dmi-id.
> 
> Subject: Fix for __you_cannot_kmalloc_that_much failure in dmi-id
> 
> gcc 3.2 has a hard time coping with the code in dmi_id_init():
> 
> drivers/built-in.o(.init.text+0x789e): In function `dmi_id_init':
> : undefined reference to `__you_cannot_kmalloc_that_much'
> make: *** [.tmp_vmlinux1] Error 1
> 
> Moving half of the code to a separate function seems to help. This is
> a no-op for gcc 4.1 which will successfully inline the code anyway.

Hi Jean,

Thank you, I have tested the patch, it fixes the build failure.


 Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
 Signed-off-by: Jean Delvare <khali@linux-fr.org>
 ---
 drivers/firmware/dmi-id.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)
 
--- linux-2.6.24-rc7.orig/drivers/firmware/dmi-id.c	2007-10-24 09:59:28.000000000 +0200
+++ linux-2.6.24-rc7/drivers/firmware/dmi-id.c	2008-01-08 10:32:00.000000000 +0100
@@ -175,12 +175,11 @@ static struct device *dmi_dev;

 extern int dmi_available;

-static int __init dmi_id_init(void)
+/* In a separate function to keep gcc 3.2 happy - do NOT merge this in
+   dmi_id_init! */
+static void __init dmi_id_init_attr_table(void)
 {
-	int ret, i;
-
-	if (!dmi_available)
-		return -ENODEV;
+	int i;
 
 	/* Not necessarily all DMI fields are available on all
 	 * systems, hence let's built an attribute table of just
@@ -205,6 +204,16 @@ static int __init dmi_id_init(void)
 	ADD_DMI_ATTR(chassis_serial,    DMI_CHASSIS_SERIAL);
 	ADD_DMI_ATTR(chassis_asset_tag, DMI_CHASSIS_ASSET_TAG);
 	sys_dmi_attributes[i++] = &sys_dmi_modalias_attr.attr;
+}
+
+static int __init dmi_id_init(void)
+{
+	int ret;
+
+	if (!dmi_available)
+		return -ENODEV;
+
+	dmi_id_init_attr_table();

 	ret = class_register(&dmi_class);
 	if (ret)

I'll now check if I can do something similar for snd-mixer-oss.
 
-- 
Jean Delvare
