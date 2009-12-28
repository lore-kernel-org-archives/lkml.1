Return-Path: <linux-kernel-owner+w=401wt.eu-S1752073AbZL1VeQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbZL1VeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 16:34:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZL1VeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 16:34:15 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:42155 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181AbZL1VeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 16:34:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Z6U63IOBqPc6mG1lro58+PnBnMPFDSXDsF6L14GNryi2YRu55Sgm0R+niEafYPb5+3
         Q9hB5IJYBLOl9JA6PP5/4FPAOmBSWg3GpWdqPIneMwg5V443svPI0Z0DEoN0KIE+5848
         6VSEmHoG6NNMVzwA8desaMBHP8nMkoI/JmHaA=
MIME-Version: 1.0
In-Reply-To: <20091228205511.GD1637@ucw.cz>
References: <20091227190802.GH11737@elf.ucw.cz> <20091228060759.GB13266@heat> 
	<20091228101006.GA19984@elf.ucw.cz> <8817.1262011044@localhost> 
	<20091228205511.GD1637@ucw.cz>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Mon, 28 Dec 2009 16:33:52 -0500
Message-ID: <3e8340490912281333l1459f769yf621a36ad1ed6482@mail.gmail.com>
Subject: Re: RFC: disablenetwork facility. (v4)
To: Pavel Machek <pavel@ucw.cz>
Cc: Valdis.Kletnieks@vt.edu, Michael Stone <michael@laptop.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "Am?rico Wang" <xiyou.wangcong@gmail.com>,
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 3:55 PM, Pavel Machek <pavel@ucw.cz> wrote:
> On Mon 2009-12-28 09:37:24, Valdis.Kletnieks@vt.edu wrote:
>> On Mon, 28 Dec 2009 11:10:06 +0100, Pavel Machek said:
>>
>> > a) make disablenetwork reset to "enablenetwork" during setuid exec
>>
>> That won't work either.  If you only make it 'setuid==0' binaries, you still
>> break 'setuid-FOO' binaries that require the net. If you just check the setuid
>> bit, it allows a trivial escape by creating a setuid-yourself binary and using
>> that to exec something else (now with network access, because we apparently
>> don't have a way to remember the previous setting).
>
>
> it is really only required for binaries setuid to someone else, but
> that would be too ugly. (Plus, as someone said, ping is great for
> leaking data out.)

No, this is not sufficient; one needs only to find a setuid process
that can be convinced to run a program with the original (pre-suid)
privileges. For example, one could invoke gpg (older versions setuid
so it can lock memory, executes user code for the passphrase input
agent) or pulseaudio (in some cases setuid to go realtime, loads user
plugins) or screen (setuid for sharing sessions, obviously executes
user programs) or at/cron (did you remember to deny access to these?)
...

Or one can target a non-root setuid program that may have security
holes - how about nethack?

While in modern distros these uses of setuid may be rare, they can
exist, and under the old security model they were safe. Not so
anymore. As such, re-enabling network access upon executing a setuid
program is not acceptable.

That said, I do feel this is a separate issue. The process should
first drop its ability to suid; then it can freely apply additional
restrictions without there being any risk of breaking setuid
applications.

In short, how does this sound:
* Add an API to allow processes to permanently revoke their own
ability to gain privileges from setuid-exec
* Add this disablenetwork facility, conditional on dropping
setuid-exec abilities

This also paves the way for:
* Allow processes that have dropped said suid ability to freely create
new namespaces (and chroot)

Which, combined with doing whatever audits are necessary to allow
cross-network-namespace uses of unix domain sockets, actually
eliminates the need for the disablenetwork API. :)
