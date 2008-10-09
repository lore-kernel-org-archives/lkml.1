Return-Path: <linux-kernel-owner+w=401wt.eu-S1758310AbYJIG30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbYJIG30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 02:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbYJIG3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 02:29:17 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:26180 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755735AbYJIG3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 02:29:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=X3dJfin3jofafVdYmX0gt2j0NGCsLhBlG9WYLWnn/8+QUjO76HgxffAdU1b5KXgA4W8P6ZiPPje2ySj8+mYm2uvL8HGopWlJQ2kZXCZRoXtUw2TrfiPSZtaA3o56Ze1fF9T6/CWIxxFtb5qBGOcID+0E/P+wpB4xuVTK6MErXoQ=  ;
X-YMail-OSG: B.BJM_oVM1ksNN._w7H3c_UyP.Pf7U7Q9Wzgr1apIfp24imV3HxGO2l9vxY6jsgBgT1I0WR4RI.ue7MJPbOQ8xhtRLg7Owe1rhC8oZFUPS4BdFb3aKK0w_CfBg56.ip8UGYckBVRtFqKixBGn_gE2S1NxCjxs3sCMA_ssqXVrjEJNFN.b2ZtUHypbBwN
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH] documentation: explain memory barriers
Date: Fri, 10 Oct 2008 04:29:05 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org
References: <20080911101616.GA24064@agk.fab.redhat.com> <20081008183125.2a24e3c2.akpm@linux-foundation.org> <48ED9BFB.4060904@redhat.com>
In-Reply-To: <48ED9BFB.4060904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="big5"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810100429.05582.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 October 2008 16:51, Chris Snook wrote:
> Andrew Morton wrote:
> > On Wed, 08 Oct 2008 21:17:58 -0400 Chris Snook <csnook@redhat.com> wrote:
> >> Randy Dunlap wrote:
> >>> On Wed, 1 Oct 2008 22:54:04 -0700 Andrew Morton wrote:
> >>>> This sequence is repeated three or four times and should be pulled out
> >>>> into a well-commented function.  That comment should explain the logic
> >>>> behind the use of these barriers, please.
> >>>
> >>> and on 2008-OCT-08 Ben Hutchings wrote:
> >>>> All memory barriers need a comment to explain why and what they're
> >>>> doing.
> >
> > I approve this message.
> >
> >> Seriously?  When a barrier is used, it's generally self-evident what
> >> it's doing.
> >
> > fs/buffer.c:sync_buffer().  Have fun.
>
> The real disaster there is the clear_buffer_##name macro and friends, as
> evidenced by fs/ext2/inode.c:599
>
>                 clear_buffer_new(bh_result); /* What's this do? */

That's not a disaster. It is relatively easy even if you have no
idea about any of that code to a) work out what BH_New flag does,
see where it gets set and where it gets cleared, and then work out
what that does. Actually, buffer.c used to leak BH_New in some
cases, but now it should be a bug if BH_New is found to be set
there (buffer.c should take any BH_New buffers, initialize them
appropriately, and clear BH_New; a dangling BH_New would indicate
uninitialized data going to or coming from the block).

No, they're easy, because you can find every single place where any
one cares about them with a single simple grep.

Again, fs/buffer.c:sync_buffer(). Which stores and/or loads is that
barrier sequencing against which subsequent stores and/or loads? Why?

For another fun example, mm/filemap.c:sync_page. This actually has a
big comment, but (to me) it isn't even evident then which loads and
stores are being sequenced against which subsequent ones because it
is not explicitly documented. And I do have some experience in adding
barriers to existing mm code where they have been missed completely.

mempool_free, set_dumpable, freeze_bdev.



> I'm completely in favor of documenting everything that can potentially
> interact with that train wreck,

What's the train-wreck, again?


> but I maintain that the vast majority of 
> memory barriers are self-evident.

They are self-evident if you have spent a lot of time getting the
state machine and locking/concurrency model in your mind. If you
have not, then how do you know there is not some memory operation
way back or forward in the instruction stream that is supposed to
be ordered by this barrier?

All memory barriers have to be documented, except acquire/release
for critical sections, IMO.
