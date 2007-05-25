Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbXEYHBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbXEYHBg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbXEYHBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:01:30 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:54231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073AbXEYHB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:01:29 -0400
Date: Fri, 25 May 2007 00:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "young dave" <hidave.darkstar@gmail.com>
Cc: "Christoph Lameter" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Anton Altaparmakov" <aia21@cantab.net>
Subject: Re: 2.6.22-rc2-mm1 NTFS & SLUB related fix
Message-Id: <20070525000115.e24e027a.akpm@linux-foundation.org>
In-Reply-To: <a8e1da0705242348n12aebed7m254677969d718bde@mail.gmail.com>
References: <a8e1da0705242201r13a26d92hcb0059f55e15a24a@mail.gmail.com>
	<Pine.LNX.4.64.0705242202340.1327@schroedinger.engr.sgi.com>
	<a8e1da0705242222n2414a66bo97d20c82c6a497e4@mail.gmail.com>
	<20070524224709.0719acfe.akpm@linux-foundation.org>
	<a8e1da0705242327q48c5d449p2fc028c40b0bfb08@mail.gmail.com>
	<20070524234353.ad493d42.akpm@linux-foundation.org>
	<a8e1da0705242348n12aebed7m254677969d718bde@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 06:48:34 +0000 "young dave" <hidave.darkstar@gmail.com> wrote:

> Yes, I'm sure.  but the patch in top post of mine works, the diffrence
> is using kzalloc and remove the  "ni->name[i] = 0;" line.
> 

Let's walk through the existing code:

		i = na->name_len * sizeof(ntfschar);

now, i = na->name_len * 2

		ni->name = kmalloc(i + sizeof(ntfschar), GFP_ATOMIC);

we allocated (na->name_len * 2 + 2) bytes

		if (!ni->name)
			return -ENOMEM;
		memcpy(ni->name, na->name, i);

we copied (na->name_len * 2) bytes

		ni->name[i] = 0;

here, we zero the two bytes at byte offsets ((na->name_len * 2) * 2) and
((na->name_len * 2) * 2 + 1), and that is the bug.  We _want_ to zero
the two bytes at byte offsets (na->name_len * 2) and (na->name_len * 2 + 1),
which we can do in C via

		ni->name[na->name_len] = 0;

because sizeof(*(ni->name)) == 2.


So I'm still suspecting that you mistested that change.
