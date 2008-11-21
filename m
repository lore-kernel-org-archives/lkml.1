Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbYKUWrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbYKUWrt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 17:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYKUWrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 17:47:41 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:33396 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbYKUWrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 17:47:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=JXUDMU7eKd5RzNpX6UjsI5vZAOM+rrCt5fT1i/p52Poir8vnT5OjdEy9yySh7HW2DQ
         q9ppx6ayCYG+puU24UG4jR/F1+x85w689gahxNWrwRuDWu/FktZPhxvT6GRLtK7R18pv
         aYfbuwPTuEb8E8P262tQfQ/fZ9o0FyBaAezbM=
Message-ID: <7c86c4470811211447p57b38ecy9520a9e5170d2ce1@mail.gmail.com>
Date: Fri, 21 Nov 2008 23:47:38 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <7c86c4470811210833l5c8005b4l675bc51df50affaa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <1227119245.6025.12.camel@raistlin>
	 <7c86c4470811191120i63b70970s3e24af5c962ea538@mail.gmail.com>
	 <1227133570.6104.10.camel@raistlin>
	 <7c86c4470811201319x2eb93d41vbdd8ce480a797fab@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F115BC@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210538i5e6958e1p2c31effa762f5914@mail.gmail.com>
	 <7c86c4470811210727o13006d5bk5bcbacb791e51b1c@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F3B93D@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811210833l5c8005b4l675bc51df50affaa@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Markus,

Perfmon does allocate its own buffer for PEBS.
That buffer contains: a perfmon header + PEBS buffer

Keep in mind that the PEBS buffer is actually remapped to user space to avoid
copying records around.

With the current code base, ds.c can accept a pre-allocated buffer.
However, it does
some adjustments for alignment and size (multiple of PEBS record
size). That means
that the start and end of the buffer could be different from the area
passed to ds_request_pebs().

To parse the buffer, a monitoring tools needs a start position and the
number of samples. The start
position can be expressed as an offset from the beginning of the
perfmon buffer.  The ds.c interface
currently only returns indexes for current position, threshold, and
end. Those indexes are good enough
to derived the number of samples. But I would need one call to return
the byte offset from the original
buffer, or the actual address (which perfmon could then convert back
to an offset from its buffer).

Thanks.

On Fri, Nov 21, 2008 at 5:33 PM, stephane eranian
<eranian@googlemail.com> wrote:
> On Fri, Nov 21, 2008 at 5:10 PM, Metzger, Markus T
> <markus.t.metzger@intel.com> wrote:
>>>-----Original Message-----
>>>From: stephane eranian [mailto:eranian@googlemail.com]
>>>Sent: Freitag, 21. November 2008 16:27
>>>To: Metzger, Markus T
>>>Cc: Markus Metzger; Ingo Molnar; Andi Kleen; Andrew Morton;
>>>linux-kernel@vger.kernel.org
>>>Subject: Re: debugctl msr
>>
>>>The absolute maximum MUST be at buffer+size+1 but the
>>>threshold can be anywhere
>>>between the start of the buffer and buffer+size. You had it set past
>>>the end of the buffer (at +1),
>>>therefore PEBS was not generating any interrupts.
>>
>> The default is cyclic mode, which requires the interrupt threshold
>> to be outside of the buffer.
>>
> That's not what I need.
>
>> A request for interrupt mode should have got you -EOPNOTSUPP.
>
> I did not try that.
>
>>
>> Absolute max should be one byte beyond the buffer, which
>> is base + size.
>>
> My bad ;-<
>
