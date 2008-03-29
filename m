Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYC2P36@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYC2P36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 11:29:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYC2P3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 11:29:49 -0400
Received: from mail2.shareable.org ([80.68.89.115]:43564 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbYC2P3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 11:29:48 -0400
Date: Sat, 29 Mar 2008 15:29:20 +0000
From: Jamie Lokier <jamie@shareable.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bob Copeland <me@bobcopeland.com>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/7] omfs: define filesystem structures
Message-ID: <20080329152920.GA10653@shareable.org>
Mail-Followup-To: Arnd Bergmann <arnd@arndb.de>,
	Bob Copeland <me@bobcopeland.com>, Pavel Machek <pavel@ucw.cz>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <1206578760-9050-1-git-send-email-me@bobcopeland.com> <20080328201940.GA3974@ucw.cz> <20080328231833.GA16515@hash.localnet> <200803290415.43189.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803290415.43189.arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> Actually, we don't normally add the attribute((packed)) in cases like
> this one, where you already have manual padding in it. Marking this
> structure packed would only cause a small performance loss on accesses
> of its members on certain architectures, but not have an impact on
> correctness.
> 
> No architecture supported by Linux requires higher than natural alignment
> for any integer types, and a lot of other code would break otherwise.

That's not quite true.  Some architectures supported by Linux add
"external" padding to the size and alignment of a structure.

	struct my_subtype {
		unsigned char st1, st2;
	};

On Linux/ARM, sizeof(my_subtype) == 4 and __alignof__(my_subtype) == 4.
On Linux/x86, sizeof(my_subtype) == 2 and __alignof__(my_subtype) == 1.

This will break code which expects them to pack into an array, or
which is accessing this structure from a 2-byte aligned address.

This also effects structures containing other structures:

	struct my_type {
		unsigned char a, b, c, d;
		struct my_subtype st[2];
		unsigned char e, f, g, h;
	};

On Linux/ARM, sizeof(my_type) == 16 and __alignof__(my_subtype) == 4.
On Linux/ARM, sizeof(my_type) == 12 and __alignof__(my_subtype) == 1.

This did break one of my programs on Linux.  I had to decide between
using __attribute__((packed)) and losing portability, or stop using a
struct to access the data which was ugly but portable (the structures
had a lot more fields than this example).

-- Jamie
