Return-Path: <linux-kernel-owner+w=401wt.eu-S1755063AbYFCNAx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063AbYFCNAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:00:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbYFCNAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:00:41 -0400
Received: from dmzmta103.na.baesystems.com ([149.32.252.103]:37061 "EHLO
	dmzmta103.na.baesystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756888AbYFCNAk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:00:40 -0400
X-Greylist: delayed 2053 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jun 2008 09:00:37 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6619.12
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Submitting fixes for bugs: Re: tun device patch for IPv6
Date: Tue, 3 Jun 2008 08:26:18 -0400
Message-ID: <81E1305DE5C9BB4089AF6F74955100D9066D9E7F@blums0017.bluelnk.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Submitting fixes for bugs: Re: tun device patch for IPv6
Thread-Index: AcjFKubWOLLukL/GSouafW/Q5CWykwASMacQ
References: <32209efe0806020804m751d71c4k1fe8339627f6dbd1@mail.gmail.com> <4844BC0B.4070809@qualcomm.com>
From: "Zabele, Stephen \(US SSA\)" <steve.zabele@baesystems.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>,
       "Natalie Protasevich" <protasnb@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 03 Jun 2008 12:26:19.0394 (UTC) FILETIME=[06AD8620:01C8C575]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max,

I am confused by your comment. As you point out, the TUN driver does
have an option that allows users to provide the protocol information as
an extended header. The problem is that there is a lot of existing IPv4
code that does not use this approach, and we'd like to make it easy for
folsk to port their existing code to work with IPv6.

Hence, the patch provided below allows existing software that does not
use the extra protocol information to work with IPv6.

If you are suggesting that "people shouldn't be using the non-PI option"
for the TUN device, then the option should be taken out to force the
issue rather than leaving an incomplete implementations lying around the
kernel and making folks spend a lot of hours trying to debug why the
non-PI version doesn't work with IPv6 -- like I did. 

I disagree with this assertion, however, because providing this
information forces a lot of extra (and in my opinion unnecessary) coding
in user space.

Steve

-----Original Message-----
From: Max Krasnyansky [mailto:maxk@qualcomm.com] 
Sent: Monday, June 02, 2008 11:36 PM
To: Natalie Protasevich
Cc: Zabele, Stephen (US SSA); Andrew Morton; LKML
Subject: Re: Submitting fixes for bugs: Re: tun device patch for IPv6

btw I naked similar patch a couple of times already.
TUN driver provide PI (protocol info) extension that lets uses set
packet
type. Please use that instead.

Max

Natalie Protasevich wrote:
> On Mon, Jun 2, 2008 at 6:53 AM, Zabele, Stephen (US SSA)
> <steve.zabele@baesystems.com> wrote:
>> Natalie,
>>
>>> Steve,
>>> Can you please submit the patch to LKML and to Maxim
>> (maxk@qualcomm.com) >via email (if you haven't already)?
>>
>> The patch is accessible from the bottom of the bugzilla web page, but
>> I'm also providing it again here for reference. I' not sure how to
>> submit it to LKML other than through the bugzilla mechanism. Can you
>> provide me a pointer??
>>
>> Thanks!
>>
>> Steve
>>
> 
> Hi Steve,
> This issue is pretty generic. Bug reporters often produce fixes, that
> remain in bugzilla not being harvested, simply because bugzilla is not
> designed for submitting patches. Even developers who work on bugzilla
> and leave their patches attached to the bug don't get those
> incorporated until they submit it conventional way.
> 
> To submit the patch properly follow
> http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt. There are
> other pointers like http://linux.yyz.us/patch-format.html,
> http://lxr.linux.no/linux/Documentation/SubmittingPatches. You can
> look at any submitted patch as a sample and examine the format; note
> that added/changed/removed lines produced with diffstat.
> 
> Maintainers deal with great number of patches, so in order to be able
> to use your patch they have go receive it in proper format i.e. with
> conventional comments and headers, such that it complies with source
> keeping process (not mentioning that it should apply to latest tree,
> so they don't have to port it...)
> Any patch that fixes a problem is valuable, so by submitting it proper
> way you'll make sure (1) your patch will get the best review possible
> (2)  you will get proper credit for it. Then you post it to LKML and
> CC to subsystem maintainer and/or developers heavily involved with
> this module.
> Thanks,
> --Natalie
> 
>> --- Cut here ---
>>
>> --- a/drivers/net/tun.c 2008-02-11 01:06:32.000000000 -0500
>> +++ b/drivers/net/tun.c 2008-03-18 15:30:55.000000000 -0400
>> @@ -243,8 +243,26 @@
>>
>>                if(memcpy_fromiovec((void *)&pi, iv, sizeof(pi)))
>>                        return -EFAULT;
>> -       }
>> -
>> +
>> +        } else if ((tun->flags & TUN_TYPE_MASK) == TUN_TUN_DEV) {
>> +                if (iv->iov_len) {
>> +                        unsigned char verbuf;
>> +
>> +                        if (copy_from_user((void *)&verbuf,
>> iv->iov_base, sizeof(verbuf)))
>> +                                return -EFAULT;
>> +
>> +                        switch (verbuf & 0xf0) {
>> +                          case 0x40:
>> +                            break;
>> +                          case 0x60:
>> +                            pi.proto = htons(ETH_P_IPV6);
>> +                            break;
>> +                          default:
>> +                            return -EINVAL;
>> +                        }
>> +                }
>> +        }
>> +
>>        if ((tun->flags & TUN_TYPE_MASK) == TUN_TAP_DEV)
>>                align = NET_IP_ALIGN;
>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

