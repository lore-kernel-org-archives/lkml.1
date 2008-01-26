Return-Path: <linux-kernel-owner+w=401wt.eu-S1756711AbYAZD3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbYAZD3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 22:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYAZD3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 22:29:03 -0500
Received: from lixom.net ([66.141.50.11]:57602 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYAZD3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 22:29:01 -0500
Date: Fri, 25 Jan 2008 21:40:55 -0600
From: Olof Johansson <olof@lixom.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 063/196] kset: convert /sys/devices to use kset_create
Message-ID: <20080126034055.GA28786@lixom.net>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-63-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201245134-4876-63-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2008 at 11:10:01PM -0800, Greg Kroah-Hartman wrote:
> Dynamically create the kset instead of declaring it statically.  We also
> rename devices_subsys to devices_kset to catch all users of the
> variable.

Guess what, you broke powerpc again!

olof@quad:~/work/linux/k.org $ git grep devices_subsys
arch/powerpc/kernel/vio.c:extern struct kset devices_subsys; /* needed for vio_find_name() */
arch/powerpc/kernel/vio.c:      found = kset_find_obj(&devices_subsys, kobj_name);

Obviously causes build failues, even of ppc64_defconfig.

(I can unfortunately not boot test, since I lack hardware that uses vio)


Signed-off-by: Olof Johansson <olof@lixom.net>

diff --git a/arch/powerpc/kernel/vio.c b/arch/powerpc/kernel/vio.c
index 19a5656..ee752ab 100644
--- a/arch/powerpc/kernel/vio.c
+++ b/arch/powerpc/kernel/vio.c
@@ -37,7 +37,7 @@
 #include <asm/iseries/hv_call_xm.h>
 #include <asm/iseries/iommu.h>
 
-extern struct kset devices_subsys; /* needed for vio_find_name() */
+extern struct kset *devices_kset; /* needed for vio_find_name() */
 
 static struct bus_type vio_bus_type;
 
@@ -369,7 +369,7 @@ static struct vio_dev *vio_find_name(const char *kobj_name)
 {
 	struct kobject *found;
 
-	found = kset_find_obj(&devices_subsys, kobj_name);
+	found = kset_find_obj(devices_kset, kobj_name);
 	if (!found)
 		return NULL;
 
