Return-Path: <linux-kernel-owner+w=401wt.eu-S1755478AbYIIX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478AbYIIX1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYIIX04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 19:26:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbYIIX0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 19:26:55 -0400
Date: Tue, 9 Sep 2008 16:26:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Parag Warudkar" <parag.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, htejun@gmail.com,
       gregkh@suse.de
Subject: Re: [PATCH] x86: sysfs - kill owner field from attribute
Message-Id: <20080909162602.e45970ec.akpm@linux-foundation.org>
In-Reply-To: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
References: <f7848160809091611w50270265hc149baeaf267775e@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2008 19:11:02 -0400
"Parag Warudkar" <parag.lkml@gmail.com> wrote:

> Tejun's commit 7b595756ec1f49e0049a9e01a1298d53a7faaa15 made sysfs
> attribute->owner unnecessary.
> But the field was left in the structure to ease the merge. It's been
> over a year since that change and it is now time to start killing
> attribute->owner along with its users - one arch at a time!
> 
> This patch is attempt #1 to get rid of attribute->owner only for
> CONFIG_X86_64 or CONFIG_X86_32 .
> We will deal with other arches later on as and when possible - avr32
> will be the next since that is something I can test.
> Compile (make allyesconfig / make allmodconfig / custom config) and boot tested.
> 

hm, OK, there may be newly-added code which will now break.  Not a big
deal.

> 
>  drivers/acpi/battery.c              |    2 +-
>  drivers/acpi/sbs.c                  |    2 +-
>  drivers/acpi/system.c               |    1 -
>  drivers/block/aoe/aoeblk.c          |    2 +-
>  drivers/block/nbd.c                 |    2 +-
>  drivers/firmware/iscsi_ibft.c       |    1 -
>  drivers/i2c/chips/at24.c            |    1 -
>  drivers/i2c/chips/ds1682.c          |    1 -
>  drivers/infiniband/core/cm.c        |    2 +-
>  drivers/memstick/core/mspro_block.c |    1 -
>  drivers/power/power_supply_sysfs.c  |    2 +-
>  drivers/rtc/rtc-cmos.c              |    1 -
>  drivers/rtc/rtc-ds1305.c            |    1 -
>  drivers/rtc/rtc-ds1307.c            |    1 -
>  drivers/rtc/rtc-ds1511.c            |    1 -
>  drivers/rtc/rtc-m48t59.c            |    1 -
>  drivers/rtc/rtc-stk17ta8.c          |    1 -
>  drivers/scsi/arcmsr/arcmsr_attr.c   |    3 ---
>  drivers/w1/slaves/w1_ds2760.c       |    1 -
>  include/linux/sysfs.h               |    7 +++++--
>  20 files changed, 11 insertions(+), 23 deletions(-)

The patch was wordwrapped - please fix that up before sending any more
patches.

> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -21,12 +21,15 @@ struct kobject;
>  struct module;
> 
>  /* FIXME
> - * The *owner field is no longer used, but leave around
> - * until the tree gets cleaned up fully.
> + * The *owner field is no longer used.
> + * x86 tree has been cleaned up. The owner
> + * attribute is still left for other arches.
>   */
>  struct attribute {
>  	const char		*name;
> +#if !defined(CONFIG_X86_64) && !defined(CONFIG_X86_32)
>  	struct module		*owner;
> +#endif
>  	mode_t			mode;
>  };

This is simpler, no?

--- a/include/linux/sysfs.h~x86-sysfs-kill-owner-field-from-attribute-fix
+++ a/include/linux/sysfs.h
@@ -27,7 +27,7 @@ struct module;
  */
 struct attribute {
 	const char		*name;
-#if !defined(CONFIG_X86_64) && !defined(CONFIG_X86_32)
+#ifndef CONFIG_X86
 	struct module		*owner;
 #endif
 	mode_t			mode;
_

