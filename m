Return-Path: <linux-kernel-owner+w=401wt.eu-S1758195AbYHYLEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758195AbYHYLEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758055AbYHYLCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:02:10 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:37051 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757568AbYHYLCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:02:08 -0400
To: serue@us.ibm.com
CC: ebiederm@xmission.com, miklos@szeredi.hu, akpm@linux-foundation.org,
       hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080808002537.GA5364@us.ibm.com> (serue@us.ibm.com)
Subject: Re: unprivileged mounts git tree
References: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu> <20080807222751.GA28412@us.ibm.com> <m1prokgyje.fsf@frodo.ebiederm.org> <20080808002537.GA5364@us.ibm.com>
Message-Id: <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 25 Aug 2008 13:01:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Serge E. Hallyn wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > "Serge E. Hallyn" <serue@us.ibm.com> writes:
> > > so on the bright side I pulled this tree today and it compiled and
> > > passed ltp with no problems.
> > >
> > > But then I played around a bit and found I could do the following:
> > >
> > > (hmm, i'm trying to remember the exact order :)
> > >
> > > as root:
> > > 	mmount --bind -o user=500 /home/hallyn/etc/ /home/hallyn/etc/
> > > 	mount --bind /mnt /mnt
> > > 	mount --make-rshared /mnt
> > > 	mount --bind /dev /mnt/dev
> > >
> > > as hallyn:
> > > 	mmount --bind /mnt /home/hallyn/etc/mnt
> > > 	/usr/src/mmount-0.3/mmount --bind mnt/dev mnt/src
> > 
> > You are using relative directory names here which makes it confusing.
> > I'm assuming you in /home/hallyn/etc ?
> 
> Sorry, yeah.
> 
> > > Now /mnt/src contained /dev.
> > >
> > > Is this what we want?
> > 
> > I don't think so.
> > 
> > I think the simplest answer is to not allow mounting of shared
> > subtrees controlled by a different user.
> > 
> > Serge I think you are right downgrading the mount from shared to slave
> > looks like the sane thing to do if the mount owners match.
> 
> I assume you mean "if the mount owners don't match"?
> 
> Miklos, what do you think?

Sorry about the late reply: I was on a long summer vacation...

Serge, thanks for spotting this: it looks indeed a nasty hole!  I also
agree about the solution.

> The next question then becomes, how can we prove to ourselves that that
> closes the last security hole with unprivileged mounts?  So long as
> we treat each mount event as a piece of information and look at it as an
> information flow problem, maybe we can actually come up with a good
> description of the logic that is implemented and show that there is no
> way a user can "leak" info...  (where a leak is a mount event, a
> violation of intended DAC on open(file) or mkdir, etc)

"Information flow problem" doesn't mean much to me (I'm actually an
electric engineer, who ended up doing programming for living ;)

But yeah, we should think this over very carefully.  Especially
interaction with mount propagation, which has very complicated and
sometimes rather counter-intuitive semantics.

Thanks,
Miklos
