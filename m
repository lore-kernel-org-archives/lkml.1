Return-Path: <linux-kernel-owner+w=401wt.eu-S1756445AbYIRTGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756445AbYIRTGj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 15:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYIRTGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 15:06:30 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:32716 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYIRTG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 15:06:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hlRmfBJnDn9KLauXuK5aGOXKf4lmWKXeUK5O7ZEfrEvBGQZeDH7Yka9XQZ1brULRwS
         XTa9v0SUCrwHkIcRKqtl9Ejnxojwv4d1rWeoZK+Ka3PW+uQApbSwL0Ysp1oguzS+cj8X
         FnLzjaIwpIMQXEZleGt3th+3lXSLCRVk/DBCI=
Message-ID: <86802c440809181206h7654077dr7d56e55817926119@mail.gmail.com>
Date: Thu, 18 Sep 2008 12:06:28 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/6] loglevel=pci:8,acpi:8,apic=8 support v6
Cc: "Jason Baron" <jbaron@redhat.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <48D2A045.5000907@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221640067-24389-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080917092732.GB32107@elte.hu> <20080917184618.GB6486@redhat.com>
	 <48D159A7.5080907@zytor.com> <20080918105728.GF20967@elte.hu>
	 <48D2758B.1000004@zytor.com> <20080918155041.GB3097@redhat.com>
	 <48D27A7E.8090403@zytor.com> <20080918161957.GC3097@redhat.com>
	 <48D2A045.5000907@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 11:39 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Jason Baron wrote:
>>
>> in my testing there was no significant difference between pre-filtering
>> vs. not built in. However, there was a measureable affect of having them
>> built in vs. not built in.
>>
>
> <somewhat irrelevant rant>
>
> Okay, I'm so bloody sick of hearing people justifying bloat by saying "no
> measurable difference."  That only means that you don't have GROSS bloat.
>  Unless you have real statistics to the contrary, most people's performance
> testing is at the very best accurate to 5-10%.  This is hardly "no bloat".
>
> </somewhat irrelevant rant>

about performance difference:
1. will have printk(KERN_level KERN_tag "...\n");
2. will have tag_printk like
    #define dev_printk(level, dev, format, arg...)  \
           printk(level KERN_DEV "%s %s: " format , dev_driver_string(dev) , \
                   dev_name(dev) , ## arg)
3. still can use MACRO for compiling time
    #ifdef DEBUG
    #define dev_dbg(dev, format, arg...)            \
           dev_printk(KERN_DEBUG , dev , format , ## arg)
    #else
    #define dev_dbg(dev, format, arg...)            \
           ({ if (0) dev_printk(KERN_DEBUG, dev, format, ##arg); 0; })
    #endif
4. with /proc/sys/kernel/printk_tag/dev could modify run-time level.
5. for big chunk dump or spew, caller could use
       level = get_tag_level(KERN_DEV, &len) and compare level to
KERN_SPEW_LEVEL or etc
   to decide if need to dump it.
6. other overhead to put tag like <dev> should be ok just like
loglevel aready in the buffer

current only have one struct  {
   char *tag;
   char *name;  /* with extra : */
   int level;
}
the level is some kind of console_loglevel for that tag.

if want to go further, let every dev_printk check that. then will not
have them in log buffer

YH
