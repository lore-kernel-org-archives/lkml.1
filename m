Return-Path: <linux-kernel-owner+w=401wt.eu-S1755079AbZHTR4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbZHTR4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 13:56:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754945AbZHTR4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 13:56:13 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:53988 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbZHTR4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 13:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Hz3KPkVsJp2xBhbYmetRXfrAoE+S35AyQtv1xVodJX+d1fc5CaCEkLCXgplvDOqM0t
         Q4dfcp8sZaVHYP5Ak/mUg51KhEp9f+PAAe7EZZVlJrrqQM1FinXYWIonsSTaArSzn+Ht
         3IckVz3Kh5/lU/jh6DFOkq0KaHgx4auIHxqkI=
Message-ID: <4A8D8E35.7060606@gnu.org>
Date: Thu, 20 Aug 2009 19:56:05 +0200
From: Paolo Bonzini <bonzini@gnu.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Lightning/1.0pre Thunderbird/3.0b3
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Avi Kivity <avi@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       gleb@redhat.com, kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] eventfd: new EFD_STATE flag
References: <20090820155655.GA8764@redhat.com> <alpine.DEB.2.00.0908200916300.14844@makko.or.mcafeemobile.com> <4A8D8A28.2050004@redhat.com> <alpine.DEB.2.00.0908201042100.14844@makko.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.2.00.0908201042100.14844@makko.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2009 07:44 PM, Davide Libenzi wrote:
> On Thu, 20 Aug 2009, Avi Kivity wrote:
>
>> On 08/20/2009 07:20 PM, Davide Libenzi wrote:
>>>
>>> I briefly looked at this while in vacation, although I did not reply
>>> hoping the horrible feeling about this code would go away.
>>> It didn't.
>>> I find this to be an ugly and ad-hoc multiplexing of eventfd with added
>>> functionalities of questionable general use.
>>> I'm pretty sure you can do better on KVM side, to solve the problem w/out
>>> littering eventfd.
>>
>> While we could argue about this my feeling is that we should drop this, at
>> least until we can quantify what benefit it has and whether there are any
>> Davide-acceptable alternatives.
>
> I really didn't mean to be harsh, but seriously, we cannot just have a
> Multiplexing Feast over eventfd, with one-time users.

EFD_STATE actually does two changes: a) makes read block until the value 
changes; b) makes each write override the previous one.  How would you 
feel if the two changes were separated?  I can see each of them has use 
cases

For example, (a) could be implemented by using select's xfds (POLLPRI) 
to poll for value changes (rfds would still poll for non-zeroness). 
Then Michael does not need even to read the eventfd; instead he'd check 
POLLIN with a zero timeout.

(b) could be implemented with a flag like Michael did.

Paolo
