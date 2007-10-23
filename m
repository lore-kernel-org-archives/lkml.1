Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbXJWPUY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbXJWPUY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:20:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXJWPUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:20:12 -0400
Received: from smtp106.sbc.mail.mud.yahoo.com ([68.142.198.205]:28681 "HELO
	smtp106.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751862AbXJWPUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:20:10 -0400
X-YMail-OSG: gM8iXH8VM1nQUbqytaM334gwE8ZpjWkSEwmHlUbjHvihMafKr9IIIiSmUIp8LqqFulpnH4Qm2z7v3rRzCs45zF1eDI6rJi9k6.XPpjHnWn3fMOUCYOLxl7m4qU31kyzNQQyuV1UKDEv0XlI-
Date: Tue, 23 Oct 2007 10:20:05 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Giacomo Catenazzi <cate@debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andreas Gruenbacher <agruen@suse.de>,
       Thomas Fricaccia <thomas_fricacci@yahoo.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: LSM conversion to static interface
Message-ID: <20071023152005.GA13767@vino.hallyn.com>
References: <167451.96128.qm@web38607.mail.mud.yahoo.com> <alpine.LFD.0.999.0710171913270.26902@woody.linux-foundation.org> <200710192226.53233.agruen@suse.de> <alpine.LFD.0.999.0710191336250.26902@woody.linux-foundation.org> <Pine.LNX.4.64.0710201255170.1997@fbirervta.pbzchgretzou.qr> <471D8A4C.3020101@debian.org> <Pine.LNX.4.64.0710231051090.16684@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710231051090.16684@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jan Engelhardt (jengelh@computergmbh.de):
> 
> On Oct 23 2007 07:44, Giacomo Catenazzi wrote:
> >
> >> I do have a pseudo LSM called "multiadm" at 
> >> http://freshmeat.net/p/multiadm/ , quoting:
> >
> >> Policy is dead simple since it is based on UIDs. The UID ranges can be 
> >> set on module load time or during runtime (sysfs params). This LSM is 
> >> basically grants extra rights unlike most other LSMs[1], which is why 
> >> modprobe makes much more sense here. (It also does not have to do any 
> >> security labelling that would require it to be loaded at boot time 
> >> already.)
> >
> >But his is against LSM design (and first agreements about LSM):
> >LSM can deny rights, but it should not give extra permissions
> >or bypass standard unix permissions.
> 
> It is just not feasible to add ACLs to all million files in /home,
> also because ACLs are limited to around 25 entries.
> And it is obvious I do not want <prof> to have UID 0, because
> then you cannot distinguish who created what file.
> So the requirement to the task is to have unique UIDs.
> The next logical step would be to give capabilities to those UIDs.
> 
> *Is that wrong*? Who says that only UID 0 is allowed to have
> all 31 capability bits turned on, and that all non-UID 0 users
> need to have all 31 capability bits turned off?
> 
> So, we give caps to the subadmins (which is IMHO a natural task),
> and then, as per LSM design (wonder where that is written) deny
> some of the rights that the capabilities raised for subadmins grant,
> because that is obviously too much.

Once the per-process capability bounding set is accepted
(http://lkml.org/lkml/2007/10/3/315) you will be able to do something
like:

	1. Create user 'jdoe' with uid 0
	2. write a pam module which, when jdoe logs in, takes
	   CAP_NET_ADMIN out of his capability bounding set
	3. Now jdoe can log in with the kind of capabilities subset
	   you describe.

It's not a perfect solution, since it doesn't allow jdoe any way at all
to directly execute a file with more caps (setuid and file capabilities
are subject to the capbound).  So there is certainly still a place for
multiadm.

-serge
