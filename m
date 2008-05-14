Return-Path: <linux-kernel-owner+w=401wt.eu-S1759891AbYENLg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759891AbYENLg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbYENLgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:36:16 -0400
Received: from imo-d21.mx.aol.com ([205.188.144.207]:65090 "EHLO
	imo-d21.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbYENLgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:36:15 -0400
Message-ID: <482ACEA2.7080300@aol.com>
Date: Wed, 14 May 2008 07:36:02 -0400
From: AndrewL733 <AndrewL733@aol.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Macbook Pro SATA Drives not seen in 2.6.25
References: <482A5C19.6090503@aol.com> <20080514010618.2e1e510a.akpm@linux-foundation.org>
In-Reply-To: <20080514010618.2e1e510a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AOL-IP: 207.180.154.47
X-Mailer: Unknown (No Version)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Andrew. Another question below.


Andrew Morton wrote:
> On Tue, 13 May 2008 23:27:21 -0400 AndrewL733 <AndrewL733@aol.com> wrote:
>
>   
>> I have a couple of Macbook Pros. The newest one -- based on the Penryn 
>> Core 2 Duo with ICH8 -- will not boot with any 2.6.25 kernel (I have 
>> tried 2.6.25 and 2.6.25.3).
>>     
>
> Let's cc linux-ide.
>
>   
>> It boots fine with 2.6.24.7 as well as with 
>> 2.6.26-rc2. It also boots fine with 2.6.22. I have specific reasons why 
>> I need to run 2.6.25 so I would appreciate any help here. It seems the 
>> SATA drives are detected, but then for each partition during bootup I see:
>>
>> ata3: SATA link down (SStatus 0 SControl 0)
>>
>> The same 2.6.25 kernels boot fine on my older Macbook Pro with ICH7 and 
>> I do not see this error.
>>
>> I would be happy to run a git bisect to help identify the issue, but if 
>> this problem is already well understood (hey, it's fixed in 2.6.26), I 
>> can think of better ways to spend my time.
>>     
>
> The below went into 2.6.25.1 (or will do so).  It looks hopful.  Can
> you test it please?
>   
Do you mean 2.6.25.4 ?  As I said above, I already tried 2.6.25.3 
yesterday and it doesn't boot.

>
>
> From: Tejun Heo <htejun@gmail.com>
>
> commit cb6716c879ecf49e2af344926c6a476821812061 upstream
>
> On certain configurations (certain macbooks), even though all the
> conditions for SIDPR access described in the datasheet are met,
> actually reading those registers just returns 0 and have no effect on
> write.  Verify SIDPR is actually working before enabling it.
>
> This is reported by Ryan Roth in bz#10512.
>
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Ryan Roth <ryan.roth@ch2m.com>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
>  drivers/ata/ata_piix.c |   25 +++++++++++++++++++++++++
>  1 file changed, 25 insertions(+)
>
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -1531,6 +1531,8 @@ static void __devinit piix_init_sidpr(st
>  {
>     struct pci_dev *pdev = to_pci_dev(host->dev);
>     struct piix_host_priv *hpriv = host->private_data;
> +   struct ata_device *dev0 = &host->ports[0]->link.device[0];
> +   u32 scontrol;
>     int i;
>  
>     /* check for availability */
> @@ -1549,6 +1551,29 @@ static void __devinit piix_init_sidpr(st
>         return;
>  
>     hpriv->sidpr = pcim_iomap_table(pdev)[PIIX_SIDPR_BAR];
> +
> +   /* SCR access via SIDPR doesn't work on some configurations.
> +    * Give it a test drive by inhibiting power save modes which
> +    * we'll do anyway.
> +    */
> +   scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
> +
> +   /* if IPM is already 3, SCR access is probably working.  Don't
> +    * un-inhibit power save modes as BIOS might have inhibited
> +    * them for a reason.
> +    */
> +   if ((scontrol & 0xf00) != 0x300) {
> +       scontrol |= 0x300;
> +       piix_sidpr_write(dev0, SCR_CONTROL, scontrol);
> +       scontrol = piix_sidpr_read(dev0, SCR_CONTROL);
> +
> +       if ((scontrol & 0xf00) != 0x300) {
> +           dev_printk(KERN_INFO, host->dev, "SCR access via "
> +                  "SIDPR is available but doesn't work\n");
> +           return;
> +       }
> +   }
> +
>     host->ports[0]->ops = &piix_sidpr_sata_ops;
>     host->ports[1]->ops = &piix_sidpr_sata_ops;
>  }
>
>   

