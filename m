Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbXAVVtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbXAVVtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:49:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932094AbXAVVtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:49:10 -0500
Received: from websrv.werbeagentur-aufwind.de ([88.198.253.206]:44488 "EHLO
	websrv2.werbeagentur-aufwind.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbXAVVtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:49:09 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jan 2007 16:49:08 EST
Subject: Re: Data corruption with raid5/dm-crypt/lvm/reiserfs on 2.6.19.2
From: Christophe Saout <christophe@saout.de>
To: Andrew Morton <akpm@osdl.org>
Cc: noah <noah123@gmail.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
In-Reply-To: <20070122115652.1f7862e1.akpm@osdl.org>
References: <d00698fb0701181211l480966e5o6f10db9300d4c8aa@mail.gmail.com>
	 <20070122115652.1f7862e1.akpm@osdl.org>
Content-Type: text/plain
Date: Mon, 22 Jan 2007 22:42:21 +0100
Message-Id: <1169502141.17211.7.camel@leto.intern.saout.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, den 22.01.2007, 11:56 -0800 schrieb Andrew Morton:

> There has been a long history of similar problems when raid and dm-crypt
> are used together.  I thought a couple of months ago that we were hot on
> the trail of a fix, but I don't think we ever got there.  Perhaps
> Christophe can comment?

No, I think it's exactly this bug. Three month ago someone came up with
a very reliable test case and I managed to nail down the bug.

Readaheads that were aborted by the raid5 code (or some layer below)
were signalled using a cleared BIO_UPTODATE bit, but no error code, and
were missed as aborted by dm-crypt (all other layers apparently set the
error code in this case, so this only happened with raid5) which could
mess up the buffer cache.

Anyway, it then turned out this bug was already "accidentally" fixed in
2.6.19 by RedHat in order to play nicely with make_request changes (the
stuff to reduce stack usage with stacked block device layers), that's
why you probably missed that it got fixed. The fix for pre-2.6.19
kernels went into some 2.6.16.x and 2.6.18.6.


