Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583AbYHRBdK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583AbYHRBdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 21:33:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750943AbYHRBdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 21:33:00 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:26018 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750858AbYHRBc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 21:32:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=fK6KSOt6zajUlZnlVY5PpZfCsFunAOMQwVND11uiuT0ZxmO/sQ4Sgbx7yQH5v079O3StPXdHHmuaix2h1Cv5/PveMTnClW7+EOSwrqoVwioB7tRxUxLi5C/nmVz3VbLa8GxJsk93+vkXveIFmhymqoDmLBHGIejh5NFsriHq524=  ;
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: kernel BUG at lib/radix-tree.c:473!
Date: Mon, 18 Aug 2008 11:32:43 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>, Johannes Weiner <hannes@saeurebad.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Kel Modderman <kel@otaku42.de>, Markus Armbruster <armbru@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Jaya Kumar <jayakumar.lkml@gmail.com>
References: <1218697362.26014.9.camel@localhost.localdomain> <Pine.LNX.4.64.0808150049110.17216@blonde.site> <1218989974.3996.4.camel@localhost.localdomain>
In-Reply-To: <1218989974.3996.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808181132.43718.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 August 2008 02:19, Ian Campbell wrote:
> On Fri, 2008-08-15 at 01:00 +0100, Hugh Dickins wrote:
> > On Fri, 15 Aug 2008, Johannes Weiner wrote:
> > > Jeremy Fitzhardinge <jeremy@goop.org> writes:
> > > > Hugh Dickins wrote:
> > > >> An additional useful input would be: what happens if you replace
> > > >> that /dev/fb0 by a symlink /dev/fb0 pointing to an fb0 device node
> > > >> in one of your disk filesystems?  I rather expect that to cause the
> > > >> same trouble, which would argue that the driver is wrong and shmem
> > > >> right.
> > > >
> > > > I don't follow. Do you mean make /dev/fb0 a plain file on a
> > > > filesystem?  Or make it a disk device node?  Something else?
> > >
> > > Creating a device node on a different filesystem to see if the driver
> > > only worked with the safe shmem set_page_dirty and now breaks due to
> > > exposure to the generic version.  Or if the driver works with the
> > > generic version through other mappings and the shmem code screws it up
> > > somewhere else.
> >
> > Yes, that's it.  I think it was ext2 I referred to, when I worried
> > about this when making the change to tmpfs; and my reading of it
> > was that ext2 left a device node's a_ops unset, as I was changing
> > tmpfs to do.  (Looking at it again, ext2 doesn't even specify its
> > .set_page_dirty, so even if it had assigned an a_ops, it wouldn't
> > have avoided the default behaviour.)  But I'd like to hear what
> > actually happens in practice, rather than relying on my reading.
>
> Creating /tmp/fb0 on an ext3 filesystem gives the same behaviour.
>
> FWIW the patch below apparently makes it work for me, but I'm not going
> to pretend I follow what's going on, why or what else it breaks ;-)

I think Iwould prefer fs_defio to use its own set_page_dirty
function. __set_page_dirty_no_writeback is supposed to be used
on pagecache, by filesystems.
