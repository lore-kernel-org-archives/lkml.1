Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab0BTHNx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 02:13:53 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:56204 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab0BTHNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 02:13:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aVTJRmA2bfRkU9b3bFd1qDV3geL30oe2/K8NdldgM5RaYpgAx+VzYNfFdp9UO+fdwA
         bi7tIGGxMeHFdpW4JKZEkljps4dJYdBq4GZXRk67THKaeTrlpbnuAkvMimek5M8l/Cpb
         ckQrO+UvPVhvr4/pKztPV5CaNOCrwQqrs2HlI=
MIME-Version: 1.0
In-Reply-To: <1266518735.3829.4.camel@jlt3.sipsolutions.net>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
Date: Sat, 20 Feb 2010 15:13:50 +0800
Message-ID: <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: multipart/mixed; boundary=0016367f99f625a32e048002f1ea
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016367f99f625a32e048002f1ea
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 19, 2010 at 2:45 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-02-18 at 08:31 -0800, Linus Torvalds wrote:
>
>> > > halt/4071 is trying to acquire lock:
>> > > =C2=A0(s_active){++++.+}, at: [<c0000000001ef868>]
>> > > .sysfs_addrm_finish+0x58/0xc0
>> > >
>> > > but task is already holding lock:
>> > > =C2=A0(&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at:
>> [<c0000000004cd6ac>]
>> > > .lock_policy_rwsem_write+0x84/0xf4
>> > >
>> > > which lock already depends on the new lock.
>>
>> You don't have a full backtrace for these things?
>
> No, it deadlocks right there, unfortunately.
>
>> We've had lots of trouble with the cpu governors, and I suspect the
>> problem isn't new, but the lockdep warning is likely new (see commit
>> 846f99749ab68bbc7f75c74fec305de675b1a1bf: "sysfs: Add lockdep
>> annotations
>> for the sysfs active reference").
>>
>> So it is likely to be an old issue that (a) now gets warned about and
>> (b) might have had timing changes enough to trigger it.
>
> Well, it used to not deadlock and actually shut down the machine :) So
> in that sense it's definitely new. It might have printed a lockdep
> warning before, which you wouldn't normally see since the machine turns
> off right after this.
>
>> I suspect it is G5-specific (or specific to whatever CPU frequency
>> code
>> that gets used there), since I think we'd have had lots of reports if
>> this
>> happened on x86.
>
> Yeah, that's puzzling me as well.
>

Does my following untested patch help?

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---------

--0016367f99f625a32e048002f1ea
Content-Type: text/plain; charset=US-ASCII; name="drivers-cpufreq-fix-deadlock.diff"
Content-Disposition: attachment; 
	filename="drivers-cpufreq-fix-deadlock.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g5w2u9l11

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMgYi9kcml2ZXJzL2NwdWZyZXEv
Y3B1ZnJlcS5jCmluZGV4IDY3YmMyZWMuLjg0MzhmMDMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1
ZnJlcS9jcHVmcmVxLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYwpAQCAtMTExMyw2
ICsxMTEzLDggQEAgc3RhdGljIGludCBfX2NwdWZyZXFfcmVtb3ZlX2RldihzdHJ1Y3Qgc3lzX2Rl
dmljZSAqc3lzX2RldikKIAl1bnNpZ25lZCBpbnQgY3B1ID0gc3lzX2Rldi0+aWQ7CiAJdW5zaWdu
ZWQgbG9uZyBmbGFnczsKIAlzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKmRhdGE7CisJc3RydWN0IGtv
YmplY3QgKmtvYmo7CisJc3RydWN0IGNvbXBsZXRpb24gKmNtcDsKICNpZmRlZiBDT05GSUdfU01Q
CiAJc3RydWN0IHN5c19kZXZpY2UgKmNwdV9zeXNfZGV2OwogCXVuc2lnbmVkIGludCBqOwpAQCAt
MTE5MiwxOSArMTE5NCwyMiBAQCBzdGF0aWMgaW50IF9fY3B1ZnJlcV9yZW1vdmVfZGV2KHN0cnVj
dCBzeXNfZGV2aWNlICpzeXNfZGV2KQogCWlmIChjcHVmcmVxX2RyaXZlci0+dGFyZ2V0KQogCQlf
X2NwdWZyZXFfZ292ZXJub3IoZGF0YSwgQ1BVRlJFUV9HT1ZfU1RPUCk7CiAKLQlrb2JqZWN0X3B1
dCgmZGF0YS0+a29iaik7CisJa29iaiA9ICZkYXRhLT5rb2JqOworCWNtcCA9ICZkYXRhLT5rb2Jq
X3VucmVnaXN0ZXI7CisJdW5sb2NrX3BvbGljeV9yd3NlbV93cml0ZShjcHUpOworCWtvYmplY3Rf
cHV0KGtvYmopOwogCiAJLyogd2UgbmVlZCB0byBtYWtlIHN1cmUgdGhhdCB0aGUgdW5kZXJseWlu
ZyBrb2JqIGlzIGFjdHVhbGx5CiAJICogbm90IHJlZmVyZW5jZWQgYW55bW9yZSBieSBhbnlib2R5
IGJlZm9yZSB3ZSBwcm9jZWVkIHdpdGgKIAkgKiB1bmxvYWRpbmcuCiAJICovCiAJZHByaW50aygi
d2FpdGluZyBmb3IgZHJvcHBpbmcgb2YgcmVmY291bnRcbiIpOwotCXdhaXRfZm9yX2NvbXBsZXRp
b24oJmRhdGEtPmtvYmpfdW5yZWdpc3Rlcik7CisJd2FpdF9mb3JfY29tcGxldGlvbihjbXApOwog
CWRwcmludGsoIndhaXQgY29tcGxldGVcbiIpOwogCisJbG9ja19wb2xpY3lfcndzZW1fd3JpdGUo
Y3B1KTsKIAlpZiAoY3B1ZnJlcV9kcml2ZXItPmV4aXQpCiAJCWNwdWZyZXFfZHJpdmVyLT5leGl0
KGRhdGEpOwotCiAJdW5sb2NrX3BvbGljeV9yd3NlbV93cml0ZShjcHUpOwogCiAJZnJlZV9jcHVt
YXNrX3ZhcihkYXRhLT5yZWxhdGVkX2NwdXMpOwo=
--0016367f99f625a32e048002f1ea--
