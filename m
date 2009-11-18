Return-Path: <linux-kernel-owner+w=401wt.eu-S1757817AbZKRQkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbZKRQkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 11:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757779AbZKRQkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 11:40:08 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:43265 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757751AbZKRQkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 11:40:07 -0500
MIME-Version: 1.0
In-Reply-To: <20091111001914.GA30470@us.ibm.com>
References: <20091110140739.GA15534@us.ibm.com>
	 <200911101028.10797.sgrubb@redhat.com>
	 <20091110155349.GA18185@us.ibm.com>
	 <200911101251.21703.sgrubb@redhat.com>
	 <20091111001914.GA30470@us.ibm.com>
Date: Wed, 18 Nov 2009 08:40:13 -0800
X-Google-Sender-Auth: d131d50a19851645
Message-ID: <551280e50911180840v5c3f2945t253c709ba2d033b2@mail.gmail.com>
Subject: Re: drop SECURITY_FILE_CAPABILITIES?
From: "Andrew G. Morgan" <morgan@kernel.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Steve Grubb <sgrubb@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-security-module@vger.kernel.org,
       Kees Cook <kees.cook@canonical.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       George Wilson <gcwilson@us.ibm.com>, KaiGai Kohei <kaigai@kaigai.gr.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 10, 2009 at 4:19 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Steve Grubb (sgrubb@redhat.com):
>> On Tuesday 10 November 2009 10:53:49 am Serge E. Hallyn wrote:
>> > > > Does anyone know of cases where CONFIG_SECURITY_FILE_CAPABILITIES=n
>> > > > is still perceived as useful?

[+1 for removing the option.]

>> > > As a library writer, I wished that the kernel behavior was either
>> > > consistent,  or there is an API that I can use to find out what model we
>> > > are operating under. The biggest issue is that for a distribution we know
>> > > the assumptions the distribution should be running under. But end users
>> > > are free to build their own kernel that has it disabled. This has already
>> > > lead to dbus not working at all.
>> > >
>> > > I also take issue with probing the capability version number returning
>> > > EINVAL  when its the only way to find out what the preferred version is.
>> >
>> > In 2007/2008, KaiGai had floated patches to export capability info
>> > over securityfs.  If it was something library writers and distros
>> > wanted, we could resurrect those patches - and tack on some info
>> > about cap-related kernel config.
>>
>> Unfortunately, I would have to support the kernels from 2.6.26->2.6.32 which
>> presumably don't have this facility. So, I'm kind of stuck. I think in a
>> previous discussion you mentioned that I could call getcap or
>> prctl(PR_CAPBSET_READ) and check for CAP_SETPCAP. I think I have to go that
>> direction for backwards compatibility.
>
> Yes, I'm afraid so - unless /proc/config.gz happened to be available.
> I suppose looking through /proc/1/status might be more reliable
> actually, in case you were running in an already-partially-restricted
> process tree.
>
>> But back to detecting the capability version number...if I pass 0 as the
>> version in the header, why can't the kernel just say oh you want the preferred
>> version number, stuff it in the header, and return the syscall with success and
>> not EINVAL?
>
> This is something I believe Andrew has advocated in the past, but I
> forget why.  Andrew?

This is so a library can understand that it doesn't understand the
current ABI. For example, consider the case of some kernel of the
future with a different ABI meeting an old library.

The intention is for it to fail safe and not blunder on doing
"security" related operations with an imperfect idea of the current
kernel interface.

This is how libcap figures out it can work with the hosting kernel:

http://git.kernel.org/?p=libs/libcap/libcap.git;a=blob;f=libcap/cap_alloc.c;h=5fa5e9305c146529e297285befa03e7c5521e9ba;hb=HEAD

Does that help explain?

>> Another irritation...if I want to clear the bounding set, I have to make a for
>> loop and call prctl 34 times (once for each bit). I'd rather see a v4
>> capability that takes the bounding set as part of the same syscall. Maybe all
>> 3 of these could be fixed in the same OS release so that changing to v4 also
>> signifies the other behavior changes.

Please don't do this. The semantics of the bounding set are very
different from capabilities, and much more of an overkill hack to cope
with a naive capability inheritance world view and not really anything
to do with "the" privilege model that capabilities represent.

> I worry a bit about people confusing the bounding set as something
> more  flexible than it is, and/or getting lazy and using the bounding
> set instead of fI|pI .vs. fP, but am not solidly against this.

Completely agree with the sentiment here.

> Anyway, maybe we should get on thsi sooner rather than later...

Or, not at all... :-)

> Are there any other deficiencies people see  in the current
> API?

I think it is worth, humbly, asking folk to read over our paper again

  http://ols.fedoraproject.org/OLS/Reprints-2008/hallyn-reprint.pdf

and trying to grok what the model is before proposing changing it.

Thanks

Andrew
