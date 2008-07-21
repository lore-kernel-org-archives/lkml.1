Return-Path: <linux-kernel-owner+w=401wt.eu-S1754471AbYGUOBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbYGUOBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 10:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752334AbYGUOBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 10:01:21 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:51947 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYGUOBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 10:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LQD9cSyqEPKoEuW8ntFCPWLUt0JsRTZbRSEKFRijO05/gu4MjKrKAm6tl7aHVi/IzG
         CO6mlf6uCBzxB7IksRMOIwjOIdPNDkgQ7gQZmS+iAoH+I3As29eO3UsoI4+01yOflAzB
         HdEEbak1k3SkTM2cvegTpb4wbSdj+7KR3bG8A=
Message-ID: <43e72e890807210701w6d7f5638w5fdbea76a1cf1c0b@mail.gmail.com>
Date: Mon, 21 Jul 2008 07:01:19 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Bug on 2.6.26 - x86 VIA Nehemiah CentaurHauls processor cannot boot
Cc: "linux kernel" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>,
       "Ivan Seskar" <Seskar@winlab.rutgers.edu>,
       jfm3 <jfm3@winlab.rutgers.edu>, Sujith <m.sujith@gmail.com>
In-Reply-To: <48848DDF.6010903@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <43e72e890807210614y58065d75j5b2fb3c5ebe6180a@mail.gmail.com>
	 <48848DDF.6010903@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 6:23 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> Luis R. Rodriguez wrote:
>>
>> This bug seems to be present since 2.6.22 [1], so hope we can get this
>> fixed ASAP. Let me know if you have patch suggestions I can test.
>>
>> This crashes very early, I had to use earlyprintk to get it.
>>
>> BUG: Int 6: CR2 00000000
>>     EDI 00000000  ESI 0009f000  EBP 00000000  ESP c036ff60
>>     EBX c03e6070  EDX 00000006  ECX 0000009f  EAX c034d240
>>     err 00000000  EIP c0387ac2   CS 00000060  flg 00010016
>> Stack: 00000000 00000000 c03b63d8 c037bb11 0001dff0 00003c00 c0399614
>> c03b6304
>>       00822007 c037aeb4 c0304134 000001df c0304117 00000000 30303030
>> 205d3030
>>       00000000 c034c794 00000000 00000000 00822007 c02b921f c034c794
>> 00000000
>> [    0.000000] Pid: 0, comm: swapper Not tainted 2.6.26 #1
>
> Use objdump -d or something to find out what is at 0xc0387ac2

I've put extra spaces between the culprit.

c0387aa0 <free_bootmem>:
c0387aa0:       57                      push   %edi
c0387aa1:       89 c7                   mov    %eax,%edi
c0387aa3:       a1 40 d2 34 c0          mov    0xc034d240,%eax
c0387aa8:       56                      push   %esi
c0387aa9:       89 d6                   mov    %edx,%esi
c0387aab:       53                      push   %ebx
c0387aac:       eb 0e                   jmp    c0387abc <free_bootmem+0x1c>
c0387aae:       89 d8                   mov    %ebx,%eax
c0387ab0:       89 f1                   mov    %esi,%ecx
c0387ab2:       89 fa                   mov    %edi,%edx
c0387ab4:       e8 67 ff ff ff          call   c0387a20 <free_bootmem_core>
c0387ab9:       8b 43 18                mov    0x18(%ebx),%eax
c0387abc:       8d 58 e8                lea    -0x18(%eax),%ebx
c0387abf:       8b 43 18                mov    0x18(%ebx),%eax

c0387ac2:       0f 1f 40 00             nopl   0x0(%eax)

c0387ac6:       81 fb 28 d2 34 c0       cmp    $0xc034d228,%ebx
c0387acc:       75 e0                   jne    c0387aae <free_bootmem+0xe>
c0387ace:       5b                      pop    %ebx
c0387acf:       5e                      pop    %esi
c0387ad0:       5f                      pop    %edi
c0387ad1:       c3                      ret

  Luis
