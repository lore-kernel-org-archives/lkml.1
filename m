Return-Path: <linux-kernel-owner+w=401wt.eu-S1752812AbYJFCva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbYJFCva (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 22:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752420AbYJFCvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 22:51:22 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:2978 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbYJFCvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 22:51:21 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYCAAMZ6Uh5LF82iGdsb2JhbACTXQEBARUipC2Bag
X-IronPort-AV: E=Sophos;i="4.33,365,1220193000"; 
   d="scan'208";a="220966777"
Date: Mon, 6 Oct 2008 13:51:16 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
Subject: Re: [PATCH 2/3] Fix fsync livelock
Message-ID: <20081006025116.GA12509@disturbed>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, agk@redhat.com, mbroz@redhat.com,
	chris@arachsys.com
References: <20080923164623.ce82c1c2.akpm@linux-foundation.org> <Pine.LNX.4.64.0809241451320.18811@hs20-bc2-1.build.redhat.com> <20081001225404.4e973465.akpm@linux-foundation.org> <Pine.LNX.4.64.0810051814060.23248@hs20-bc2-1.build.redhat.com> <20081005153306.7e644c9f@infradead.org> <Pine.LNX.4.64.0810051901190.31780@hs20-bc2-1.build.redhat.com> <20081005160724.54dd1a27@infradead.org> <Pine.LNX.4.64.0810051910580.663@hs20-bc2-1.build.redhat.com> <20081005162847.7bf0ead1@infradead.org> <Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0810051949290.5798@hs20-bc2-1.build.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2008 at 08:01:46PM -0400, Mikulas Patocka wrote:
> This looks madly complicated. And ineffective, because if some page was 
> submitted before fsync() was invoked, and is under writeback while fsync() 
> is called, fsync() still has to wait on it.

fsync() waiting on pre-issued writeback pages is the correct
behaviour.

IOW, if the page is under writeback at the time an fsync() is
issued (e.g. issued by pdflush), the page was *not clean* at the
time the fsync() was called and hence must be clean when fsync()
returns. fsync() needs to wait for all pages under I/O at the time
it is called, not just the dirty pages it issues I/O on.....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
