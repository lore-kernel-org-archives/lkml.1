Return-Path: <linux-kernel-owner+w=401wt.eu-S1754601AbYLTWgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601AbYLTWgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 17:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYLTWgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 17:36:03 -0500
Received: from mail-bw0-f21.google.com ([209.85.218.21]:49673 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbYLTWgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 17:36:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=gCDw3gLbr+TUhpBbyfYxwJzMDaEBzYGG93CRT93NxY+gesuk231J0o8cipNQPlOHGZ
         WiDcjcqoBs1gIhIkA3xNDW6UEsoEsfgvX89mUn0o+A37d8J2xulDQigguy6puPO+z6AX
         7ikqa300xbVNv5FN3dxq7qm0f+6FQ3eu62fho=
Message-ID: <19f34abd0812201435w5af47d92nce53a54e18f8c306@mail.gmail.com>
Date: Sat, 20 Dec 2008 23:35:58 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: [PATCH 04/26] kbuild: introduce $(kecho) convenience echo
Cc: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "Mike Frysinger" <vapier@gentoo.org>
In-Reply-To: <20081220192543.GA2162@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081220142518.GA19390@uranus.ravnborg.org>
	 <1229783497-19550-4-git-send-email-sam@ravnborg.org>
	 <19f34abd0812200713i76261f99t2bae7c0e4a5460de@mail.gmail.com>
	 <20081220192543.GA2162@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2008 at 8:25 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Sat, Dec 20, 2008 at 04:13:36PM +0100, Vegard Nossum wrote:
>> Hi,
>>
>> On Sat, Dec 20, 2008 at 3:31 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
>> > From: Mike Frysinger <vapier@gentoo.org>
>> >
>> > There is a bunch of places in the build system where we do 'echo' to show
>> > some nice status lines.  This means we still get output when running in
>> > silent mode.  So declare a new KECHO variable that only does 'echo' when we
>> > are in a suitable verbose build mode.
>> >
>> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
>> > [sam: added Documentation]
>> > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
>> > ---
>> >  Documentation/kbuild/makefiles.txt |   14 ++++++++++++++
>> >  scripts/Kbuild.include             |    7 +++++++
>> >  2 files changed, 21 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/Documentation/kbuild/makefiles.txt b/Documentation/kbuild/makefiles.txt
>> > index 7a77533..51104f9 100644
>> > --- a/Documentation/kbuild/makefiles.txt
>> > +++ b/Documentation/kbuild/makefiles.txt
>> > @@ -383,6 +383,20 @@ more details, with real examples.
>> >        to prerequisites are referenced with $(src) (because they are not
>> >        generated files).
>> >
>> > +    $(kecho)
>> > +       echoing information to user in a rule is often a good practice
>> > +       but when execution "make -s" one does not expect to see any output
>> > +       except for warnings/errors.
>> > +       To support this kbuild define $(kecho) which will echo out the
>> > +       text following $(kecho) to stdout except if "make -s" is used.
>> > +
>> > +       Example:
>> > +               #arch/blackfin/boot/Makefile
>> > +               $(obj)/vmImage: $(obj)/vmlinux.gz
>> > +                       $(call if_changed,uimage)
>> > +                       @$(kecho) 'Kernel: $@ is ready'
>> > +
>> > +
>> >  --- 3.11 $(CC) support functions
>> >
>> >        The kernel may be built with several different versions of
>> > diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
>> > index 936940b..8cf87e8 100644
>> > --- a/scripts/Kbuild.include
>> > +++ b/scripts/Kbuild.include
>> > @@ -25,6 +25,13 @@ basetarget = $(basename $(notdir $@))
>> >  escsq = $(subst $(squote),'\$(squote)',$1)
>> >
>> >  ###
>> > +# Easy method for doing a status message
>> > +       kecho := :
>> > + quiet_kecho := echo
>> > +silent_kecho := :
>> > +kecho := $($(quiet)kecho)
>>
>> Hm, why don't we put
>>
>>   +kecho := @$($(quiet)kecho)
>>
>> instead, so each caller can omit the @? And the example would then be:
>>
>> > +               $(obj)/vmImage: $(obj)/vmlinux.gz
>> > +                       $(call if_changed,uimage)
>> > +                       $(kecho) 'Kernel: $@ is ready'
>>
>> It seems to work correctly over here.
>
> kecho is used in scripts too where the '@' does not fly.
> I considered adding another variant for scripts but that was too much
> compared to the few users.

Ah, that's true. I'm sorry, I did not read the follow-up patch. Adding
another variant would also not make any difference from just adding
the @ where it is necessary :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
