Return-Path: <linux-kernel-owner+w=401wt.eu-S1752104AbZL1PYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbZL1PYb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 10:24:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZL1PY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 10:24:28 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:56181 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZL1PYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 10:24:24 -0500
MIME-Version: 1.0
In-Reply-To: <20091226195043.GA1945@heat>
References: <20091225055034.GA374@us.ibm.com> <20091226195043.GA1945@heat>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 28 Dec 2009 10:24:01 -0500
Message-ID: <f73f7ab80912280724l10aef7ber4d4dc8da5aeaafa2@mail.gmail.com>
Subject: Re: A basic question about the security_* hooks
To: Michael Stone <michael@laptop.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@ucw.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 14:50, Michael Stone <michael@laptop.org> wrote:
>> I ask bc the API is in the prctl code, so the LSM
>> is conceptually always there, which is different from other LSMs.
>
> The goal is to provide a stupidly simple unprivileged per-process network
> isolation primitive which is broadly available "without jumping through
> hoops".
>
> (See http://cr.yp.to/unix/disablenetwork.html for a nice writeup.)
> I need a primitive like this to further my work on the OLPC Bitfrost
> security
> architecture and to further my more general work on advancing the state of
> sandboxing technology. (See sandboxing.org.)
>
> I'm willing to entertain pretty much any implementation or interface request
> which meets that goal and which implements the desired semantics.

If you aren't using SELinux at this time (and therefore have no
existing policy), then it's actually pretty straightforward
(relatively speaking) to set up for your particular goals.  On top of
that, once you actually get the system set up, it's very easy to
extend your sandbox security model to additional processes, actions,
etc.

In this example, you would set up a very minimal stripped-down SELinux
policy in which you only define 3 types (file_t, regular_t and
nonetwork_t).  Any process would be allowed to "dyntransition" from
regular_t to nonetwork_t, but not the reverse.  regular_t would be
allowed to do anything.  nonetwork_t would be allowed to do anything
that (A) does not involve the network *and* (B) does not compromise a
regular_t process.  file_t would only be used for on-disk files.

If you want to have some program binaries *automatically* run in
nonetwork_t, you would add 1 extra type: nonetwork_exec_t.  You would
include a rule "type_transition regular_t nonetwork_exec_t:process
nonetwork_t;" in your policy, and then allow anyone to relabel files
between the labels "file_t" and "nonetwork_exec_t".  Any program file
labelled "nonetwork_exec_t" would automatically execute as
"nonetwork_t" and therefore be properly sandboxed.

The default SELinux policies are rather fantastically complicated,
mainly because they have a goal of locking down an entire GUI-enabled
system.  If all you need is something much simpler, the policy
language is very flexible and easy to customize.

The best part is... when you discover you need to control additional
actions, you can do so at runtime with zero risk of crashing the
kernel (although you can always lock yourself into a box and force a
reboot with bad security policy).

Cheers,
Kyle Moffett
