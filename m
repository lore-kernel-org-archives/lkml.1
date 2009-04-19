Return-Path: <linux-kernel-owner+w=401wt.eu-S1760871AbZDSOvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760871AbZDSOvS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 10:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760044AbZDSOvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 10:51:05 -0400
Received: from fmailhost03.isp.att.net ([204.127.217.103]:59503 "EHLO
	fmailhost03.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758323AbZDSOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 10:51:03 -0400
X-Originating-IP: [69.76.240.125]
Message-ID: <49EB3A40.10307@lwfinger.net>
Date: Sun, 19 Apr 2009 09:50:40 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, John W Linville <linville@tuxdriver.com>,
       bernhard@schiffner-limbach.de
Subject: Re: [PATCH] rtl8187se staging: Fix compilation warnings and procfs
 directory leak
References: <49ea87c4.jfXxKzrtSmTK5/lF%Larry.Finger@lwfinger.net> <20090419053851.GA25290@kroah.com>
In-Reply-To: <20090419053851.GA25290@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Apr 18, 2009 at 09:09:08PM -0500, Larry Finger wrote:
>> Please incorporate this patch in wireless/staging as soon as is possible.
>> I'm not sure what the rules are concerning such changes.
> 
> I take stuff through my staging tree, it has nothing to do with the
> wireless tree.

That was a slip of the keyboard.

>> I have a number of patches that clean up the vendor code; however, I think
>> I will hold them for the moment as they do not change the function of this
>> driver and only improve the readability.
> 
> Why wait?

The only reason is that I'm hoping that the port will allow the staging driver
to be deleted. If you want the bigger changes now, I would be happy to oblige.
FYI, the bigger patches will change 14 files with a total of 233 insertions and
1930 deletions.

>> -#define RTL8180_MODULE_NAME "rtl8180"
>> +#define RTL8180_MODULE_NAME "r8180"
> 
> Why change the name?

I want to distinguish this one from the mainline driver for the RTL8180/RTL8185
that uses the name "rtl8180". Perhaps rtl8187se would have been better; however,
that is the name I will use for the new mainline driver.

>> --- linux-2.6.orig/drivers/staging/rtl8187se/r8180_core.c
>> +++ linux-2.6/drivers/staging/rtl8187se/r8180_core.c
>> @@ -640,11 +640,9 @@ void rtl8180_proc_init_one(struct net_de
>>  {
>>  	struct proc_dir_entry *e;
>>  	struct r8180_priv *priv = (struct r8180_priv *)ieee80211_priv(dev);
>> -	priv->dir_dev = create_proc_entry(dev->name,
>> -					  S_IFDIR | S_IRUGO | S_IXUGO,
>> -					  rtl8180_proc);
>> +	priv->dir_dev = rtl8180_proc;
>>  	if (!priv->dir_dev) {
>> -		DMESGE("Unable to initialize /proc/net/rtl8180/%s\n",
>> +		DMESGE("Unable to initialize /proc/net/r8180/%s\n",
>>  		      dev->name);
>>  		return;
>>  	}
> 
> So put the files in the root proc dir?

Sure, if you think that would be better. The problem that I am fixing is that
the vendor code put the files in /proc/net/rtl8180/wlan0/XXX and then failed to
delete the wlan0 directory. I wanted to make the minimum changes for it to work
correctly.

>> @@ -1736,17 +1727,7 @@ short alloc_tx_desc_ring(struct net_devi
>>  		 * descriptor's buffer must be 256 byte aligned
>>  		 * we shouldn't be here, since we set DMA mask !
>>  		 */
>> -		DMESGW("Fixing TX alignment");
>> -		desc = (u32*)((u8*)desc + 256);
>> -#if (defined(CONFIG_HIGHMEM64G) || defined(CONFIG_64BIT_PHYS_ADDR))
>> -		desc = (u32*)((u64)desc &~ 0xff);
>> -		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
>> -		dma_desc = (dma_addr_t)((u64)dma_desc &~ 0xff);
>> -#else
>> -		desc = (u32*)((u32)desc &~ 0xff);
>> -		dma_desc = (dma_addr_t)((u8*)dma_desc + 256);
>> -		dma_desc = (dma_addr_t)((u32)dma_desc &~ 0xff);
>> -#endif
>> +		WARN(1, "DMA buffer is not aligned\n");
>>  	}
>>  	tmp=desc;
>>  	for (i=0;i<count;i++)
> 
> What replaces this logic?  Is it not needed anymore?

AFAIK, it was only needed if the kernel's DMA memory allocation failed. As we
know, that code is now perfect ;), I thought that a simple kernel warning would
be sufficient. Besides, I'm not smart enough to get the old code to compile
without warnings on x86_64 architecture. I'm not sure about i386 machines. So
far in testing, the warning has not triggered.

Larry

