Return-Path: <linux-kernel-owner+w=401wt.eu-S1764049AbZD3Wpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764049AbZD3Wpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758513AbZD3WpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:45:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753319AbZD3WpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:45:00 -0400
Date: Thu, 30 Apr 2009 15:40:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josef Bacik <jbacik@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com, jbacik@redhat.com, stable@kernel.org
Subject: Re: [PATCH] fiemap: fix problem with setting FIEMAP_EXTENT_LAST
Message-Id: <20090430154047.5485759f.akpm@linux-foundation.org>
In-Reply-To: <1241113491-9031-1-git-send-email-jbacik@redhat.com>
References: <1241113491-9031-1-git-send-email-jbacik@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 13:44:51 -0400
Josef Bacik <jbacik@redhat.com> wrote:

> This patch fixes a problem where the generic block based fiemap stuff would not
> properly set FIEMAP_EXTENT_LAST on the last extent.  I've reworked things to
> keep track if we go past the EOF, and mark the last extent properly.  The
> problem was reported by and tested by Eric Sandeen.
> 

bleeearrggh.  __generic_block_fiemap() needs to be dragged out, shot,
stabbed and doused in gasoline.

- uses stupid helper macros (blk_to_logical, logical_to_blk), thus
  carefully obscuring the types of their incoming args and return value.

- has kerneldoc which documents non-existent arguments and fails to
  document the actual arguments.

- has a local variable called `tmp'.

- Uses random and seemingly irrational mixture of u64's and `long
  long's, thus carefully confusing readers who would prefer to see
  loff_t, sector_t, etc so they have a fighting chance of understanding
  what the hell the thing does.

- exists as useful counterexample for Documentation/CodingStyle

- has undocumented locals called "length", "len" and "map_len", to
  avoid any possibility of confusion.

- has a local called `start_blk' which has a suspiciously-small
  32-bit type.  Because of all the above intense obfuscation efforts I
  just cannot be assed working out whether or not if this is an actual
  bug.


Who the heck merged this turkey?

<checks>

Oh good, it wasn't me.

your patch:

- adds a string of booleans, unhelpfully typed with plain old `int'.

- seems to think that sentences start with lower-case letters.


Sigh.

Does this bugfix need to be backported into 2.6.29?  Earlier?  If so, why?

Thanks.
