Return-Path: <linux-kernel-owner+w=401wt.eu-S1754463AbZD0IxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbZD0IxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 04:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753097AbZD0Iw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 04:52:59 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:57669 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZD0Iw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 04:52:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Kc35exUMCRGZZvKoJ+uioKjfZWGpknjhNHS1Og9sjR+ZKlSPjw5B5jvoRJyDD4ukOe
         pKHGemllLUV/0E2+9teIzWR0SkFQNlM/3O4A0mgmsLTAdhBhLOqncSPEKKoeCQCmVa1X
         9MGD9c/Wdx5TwnSXEo2epwpPZO72EhT2V5x+I=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
	 <egHshlwQQFE.A.KjC.JpE9JB@chimera>
	 <alpine.DEB.2.00.0904261314430.18988@chino.kir.corp.google.com>
Date: Mon, 27 Apr 2009 11:52:56 +0300
X-Google-Sender-Auth: f0f2beea58b8763e
Message-ID: <84144f020904270152o6567e84cj914934120315bf90@mail.gmail.com>
Subject: Re: [Bug #13112] Oops in drain_array
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Bart <mmx@riz.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Christoph Lameter <cl@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Apr 2009, Rafael J. Wysocki wrote:
>> This message has been generated automatically as a part of a report
>> of regressions introduced between 2.6.28 and 2.6.29.
>>
>> The following bug entry is on the current list of known regressions
>> introduced between 2.6.28 and 2.6.29.  Please verify if it still should
>> be listed and let me know (either way).
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=13112
>> Subject               : Oops in drain_array
>> Submitter     : Bart <mmx@riz.pl>
>> Date          : 2009-04-14 10:21 (13 days old)
>> References    : http://marc.info/?l=linux-kernel&m=123970493224628&w=4

On Sun, Apr 26, 2009 at 11:19 PM, David Rientjes <rientjes@google.com> wrote:
> Bart, is it possible to try with CONFIG_DEBUG_SLAB enabled?

Please also enable CONFIG_DEBUG_LIST. Looking at the oops:

  18:   4a 8b 8c eb 68 01 00    mov    0x168(%rbx,%r13,8),%rcx # l3 =
cachep->nodelists[node];
  1f:   00
  20:   48 8b 16                mov    (%rsi),%rdx
  23:   48 8b 46 08             mov    0x8(%rsi),%rax
  27:   48 89 42 08             mov    %rax,0x8(%rdx)
  2b:*  48 89 10                mov    %rdx,(%rax)     <-- trapping instruction
  2e:   89 e8                   mov    %ebp,%eax
  30:   48 c7 06 00 01 10 00    movq   $0x100100,(%rsi)
  37:   48 c7 46 08 00 02 20    movq   $0x200200,0x8(%rsi)

it seems like list_del() in free_block() explodes because because
->prev ("rax") of slab->list is bogus ("0000000000000cd0").

                                Pekka
