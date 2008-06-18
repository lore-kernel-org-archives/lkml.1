Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbYFRFUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbYFRFUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 01:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYFRFT6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 01:19:58 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:47192 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753357AbYFRFT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 01:19:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=pJRsp/Na2tZaoOug9njf00FAFxSkfafajt+6bZO83ypxVmZGRQvytLObZEyIhGDPaAl3/g3YJK2oNiUmXhldVShZdyQkjr8IZALux2lkjrD1j6J0SigZz2ahMRdpYq9GsdBnBKE/11Ga2b6nCdZ0VzGoJ5A2vDtJPpJ78iteFDE=  ;
X-YMail-OSG: zovrg_4VM1mX.pJEMW1ynu3wNqF7q3gHFCgJGmXlyYlzs_T.fqvhGbtUDwu7knvlfU1vxZL.Y7NaH0pAY.p.yKRKkONM9hihfymVsCIS7SMQZi.epepQed100ZkQruMSKLw-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in 2.6.26-rc5-mm3
Date: Wed, 18 Jun 2008 15:19:46 +1000
User-Agent: KMail/1.9.5
Cc: Hugh Dickins <hugh@veritas.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Kosaki Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <Pine.LNX.4.64.0806171925200.21436@blonde.site> <1213730922.8707.57.camel@lts-notebook>
In-Reply-To: <1213730922.8707.57.camel@lts-notebook>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806181519.46661.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 June 2008 05:28, Lee Schermerhorn wrote:
> On Tue, 2008-06-17 at 19:33 +0100, Hugh Dickins wrote:
> > On Tue, 17 Jun 2008, Lee Schermerhorn wrote:
> > > Now I wonder if the assertion that newpage count == 1 could be
> > > violated? I don't see how.  We've just allocated and filled it and
> > > haven't unlocked it yet, so we should hold the only reference.  Do you
> > > agree?
> >
> > Disagree: IIRC, excellent example of the kind of assumption
> > that becomes invalid with Nick's speculative page references.
> >
> > Someone interested in the previous use of the page may have
> > incremented the refcount, and in due course will find that
> > it's got reused for something else, and will then back off.
>
> Yeah.  Kosaki-san mentioned that we'd need some rework for the
> speculative page cache work.  Looks like we'll need to drop the
> VM_BUG_ON().
>
> I need to go read up on the new invariants we can trust with the
> speculative page cache.

I don't know if I've added a summary, which is something I should
do.

The best thing to do is never use page_count, but just use get
and put to refcount it. If you really must use it:

- If there are X references to a page, page_count will return >= X.
- If page_count returns Y, there are no more than Y references to the page.

