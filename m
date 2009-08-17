Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZHQP0p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZHQP0p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:26:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbZHQP0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:26:44 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:41100 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686AbZHQP0o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:26:44 -0400
MIME-Version: 1.0
In-Reply-To: <2359eed20908170738w4b3c5980x4e1defb2ed8e773c@mail.gmail.com>
References: <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
	 <20090814133225.GB27905@us.ibm.com>
	 <2359eed20908140840u2886b8dci4ce72914fc2b1ea9@mail.gmail.com>
	 <551280e50908151022tde71278gc0a745c52a8415ed@mail.gmail.com>
	 <2359eed20908152124s1af8d95eu7d4706ec3a50bc33@mail.gmail.com>
	 <551280e50908162150g3764d6caqf4de130befb7789f@mail.gmail.com>
	 <2359eed20908170738w4b3c5980x4e1defb2ed8e773c@mail.gmail.com>
Date: Mon, 17 Aug 2009 08:26:42 -0700
X-Google-Sender-Auth: c50d9787deeca578
Message-ID: <551280e50908170826o6f189354n4fd64a1cb601489f@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/1] support optional non-VFS capability inheritance 
	without disabling file caps
From: "Andrew G. Morgan" <morgan@kernel.org>
To: Will Drewry <redpig@dataspill.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 7:38 AM, Will Drewry<redpig@dataspill.org> wrote:
> Hi Andrew,
>
> Cool, so yes, I would like for a parent process to be able to
> grant a subset of its privileges to its children.
>
> I am interested in this approach for two reasons:
> 1. provides xattr-less filesystem SECURE_NOROOT 'support'
> 2. provides ephemeral capabilities
>
> For #1, I concede that there are any number of workarounds to achieve
> xattr support on a given system.  As with any workaround, they come with
> some overhead, be it in additional kernel support or in system
> management overhead.  However, those can be dealt with at a non-kernel
> level for the most part.
>
> For #2, it is currently the case that if a given user can run a binary
> with capabilities, they can always run it with those capabilities, just
> like a SUID binary.  I would like support to empower a given process
> tree with a capability that is not granted unless that process tree has
> been traversed.
>
> IMHO, a good example is /usr/bin/pulseaudio.  On most distributions, it
> is a SUID binary, but it could probably get by with cap_sys_rawio+ep.
> However, even with 'setcap cap_sys_rawio+ep', it would still provide the
> attack platform used in several recent kernel NULL pointer dereferencing
> exploits.  Any user that can normally execute pulseaudio can do so at
> anytime.  However, it would be preferable if a user's pulseaudio sound
> server was run once with privilege (on X11 login, perhaps) instead of
> anytime during a given session.
>
> It is almost possible to achieve #2 on existing systems, assuming xattr
> support can always be achieved.
> Step 1, setcap cap_sys_rawio+i /usr/bin/pulseaudio
> Step 2, pam_cap at X11 login to add cap_sys_rawio+i for a user session
> (alternately, use capsh).
> Step 3, run pulseaudio (pP' = (...) | (fI & pI) => cap_sys_rawio+ip)

What about filecaps of cap_sys_rawio+eip on pulseaudio. With the
bounding set suppressing cap_sys_rawio?

In this case, only a process with (pI & cap_sys_rawio) can exec()ute
pulseaudio, let alone use the capability. That is, the filecap +pe
implies that the capability is required for the app to run, but the
bounding set suppresses the bit from the file's xattr...! The only way
that the exec()d program can get this required bit is from the (pI &
fI), and so only if a process has (pI & cap_sys_rawio) will it be able
to invoke the program...

Cheers

Andrew

>
> It would mean that that specific user-session could launch pulseaudio
> with cap_sys_rawio+ip but not necessarily any active user with +x
> privileges on the pulseaudio binary. In addition, at any point in the
> session, cap_sys_rawio could be dropped permanently which would block
> future reuse/abuse (without relogin).
>
> The problem with this approach is that many existing applications are
> capability-ignorant.  Since the capabilities granted above
> would be in the inherited and permitted sets only, these legacy
> applications would still lack the privileges they need -- even if only
> because they are too dumb to fix it.  To get the same effect, each of
> these daemons/packages/etc will need to be patched to attempt to setpcap
> any capabilities they might need to move them into the effective set.
>
> My proposal would alleviate the need to independently patch existing code
> and would avoid filesystem-related workarounds.  I'm looking at the
> change as a compatibility feature. root privileges could be parceled but
> still inherited - but only when the new securebit is set.
>
> I hope that I'm making a bit more sense this go around.  Sorry for any
> confusion.
>
> thanks!
> will
>
> On Sun, Aug 16, 2009 at 11:50 PM, Andrew G. Morgan<morgan@kernel.org> wrote:
>> Will,
>>
>> I've read this over a few times, but the in-lining is confusing me.
>> The idea of tying privilege only to 'anointed' binaries is the "POSIX"
>> capabilities model.
>>
>> If you are willing to concede that one can always arrange xattrs to be
>> convenient with various filesystem mounting techniques, are you saying
>> you would like all executables to be able to wield privilege if their
>> parent wants to give it to them?
>>
>> Thanks
>>
>> Andrew
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
