Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab0BKUW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:22:59 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33894 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755894Ab0BKUW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ahN0suPLHtNjJ0n1WxvIQSiveq8L5QfKDczMmcMkafeQ/fcnkHEl2mnXXlNIBFRStO
         NsR0F5euQIgJdJtmkKsp87NDpnVKhBEGBjxyt/vU5wph5+9SKjFfHzo+Jq4w9QNPT7bO
         Gyg1zuHX3mtCZpzH16Ry/O6kLHTIpRRZbtoFE=
Message-ID: <4B7466F7.6070907@gmail.com>
Date: Thu, 11 Feb 2010 15:22:15 -0500
From: Chandra Shekhar Sah <edu4madh@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.5; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1 ThunderBrowse/3.2.8.1
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: port multiplier problem
References: <4B5885F7.2020007@gmail.com> <4B6833DD.1020001@gmail.com>	 <4B683581.7070708@kernel.org> <4B683DEF.3000302@gmail.com>	 <da824cf31002020844r12cada26x57f96b0aa24b59c6@mail.gmail.com>	 <4B686B2B.2080406@gmail.com>	 <da824cf31002021104v72efcd05ne639091042d5999d@mail.gmail.com>	 <4B687B7C.2070406@gmail.com>	 <da824cf31002031837t1cf2357bsbb53a3b4ea5e671f@mail.gmail.com>	 <4B6A3DED.6060708@kernel.org> <da824cf31002040959y63f3484cv6d551acd49b80fa7@mail.gmail.com>
In-Reply-To: <da824cf31002040959y63f3484cv6d551acd49b80fa7@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Any suggestion?

Thanks,
Chandra

On 2/4/10 12:59 PM, Grant Grundler wrote:
> On Wed, Feb 3, 2010 at 7:24 PM, Tejun Heo<tj@kernel.org>  wrote:
>    
>> On 02/04/2010 11:37 AM, Grant Grundler wrote:
>>      
>>> I had two questions on that thread that never got answered:
>>>     http://markmail.org/message/snpekoj4qexrslk5
>>>
>>> | How can we find out if anyone has the SEMB properly wired up?
>>> | Would it be hard to make libata aware of "SEMB port not responding" case?
>>> | ie if the SEMB port times out or has no link, reduce the port count of
>>> | the sil3726 PMP by one.
>>> |
>>> | Maybe add a "enable_sil24_semb" flag to libata?
>>> | (avoid checking unless someone asks for it). I hate magic flags but also
>>> | don't want to subject most people to the timeout delay.
>>>
>>> I (or Gwendal) can post a patch (and lightly test) for any of the above.
>>> Just need to get some guidance so we don't waste our time.
>>>        
>> It's not really sil24 tho.  But anyways, I think we can just disable
>> them altogether.  It's not like they have ever worked.  Just limiting
>> both 3726 and 4726 to 5 ports should be fine.
>>      
> Sorry - You are right. I meant "enable_sil3726_semb".
>
> I'm not sure we need to limit the SEMB ports anymore either. See below.
>
>    
>>   That said, I'm not
>> quite sure this is relevant to the reported problem but it's worth a
>> shot.
>>      
> I didn't have a better idea.
>
> I'm seeing this in sata_pmp_quirks() since ATA_LFLAG_NO_SRST was introduced:
>   337 static void sata_pmp_quirks(struct ata_port *ap)
>   338 {
>   339         u32 *gscr = ap->link.device->gscr;
>   340         u16 vendor = sata_pmp_gscr_vendor(gscr);
>   341         u16 devid = sata_pmp_gscr_devid(gscr);
>   342         struct ata_link *link;
>   343
>   344         if (vendor == 0x1095&&  devid == 0x3726) {
>   345                 /* sil3726 quirks */
>   346                 ata_for_each_link(link, ap, EDGE) {
>   347                         /* Class code report is unreliable and SRST
>   348                          * times out under certain configurations.
>   349                          */
>   350                         if (link->pmp<  5)
>   351                                 link->flags |= ATA_LFLAG_NO_SRST |
>   352                                                ATA_LFLAG_ASSUME_ATA;
>   353
>   354                         /* port 5 is for SEMB device and it
> doesn't like SR     ST */
>   355                         if (link->pmp == 5)
>   356                                 link->flags |= ATA_LFLAG_NO_SRST |
>   357                                                ATA_LFLAG_ASSUME_SEMB;
>   358                 }
>
>
> But the ATA_LFLAG_NO_SRST used in line 351 is not present in the
> 2.6.26 tree I know works with PMPs. The original commit comment isn't
> specific about exactly which HW had problems:
>      http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg24335.html
>
>     "Some links on some PMPs locks up on SRST and/or report incorrect
>      device signature.  Implement ATA_LFLAG_NO_SRST, ASSUME_ATA and
>      ASSUME_SEMB to handle these quirky links.  NO_SRST makes EH avoid
>      SRST.  ASSUME_ATA and SEMB forces class code to ATA and SEMB_UNSUP
>      respectively.  Note that SEMB isn't currently supported yet so the
>      _UNSUP variant is used."
>
>
> Can you publish which PMP implementations sometimes lock up on SRST?
>
> I doubt this is related to the problem Chandra is seeing but again,
> don't have better ideas.
>
> BTW, this same kernel works fine without disabling port 5 (SEMB port).
> I didn't know
> this until I just looked. I know previous source trees Google used
> ignored SEMB port
> on 3726 and I mistakenly assumed this one did too. :(
>
> thanks,
> grant
>
>    

