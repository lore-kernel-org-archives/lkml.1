Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662Ab0A1MHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0A1MHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 07:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754175Ab0A1MHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 07:07:38 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:60819 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab0A1MHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 07:07:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bQgwvwyEb03FDEkf/owoUG2CDVkP5MUwEJbXZtvNO8tQDQYq4+zv25HfefGtfVtd1O
         UOHfvqXogIs4XC4KspaxLpk0i7QITtQihtWRZfO2KLSUWf8nkPPxZVHjc97T7eY0VDcB
         cXEVR9j5365oHdC+7G1/fdsygX+oARAHaoB+U=
Message-ID: <4B617E03.1050403@panasas.com>
Date: Thu, 28 Jan 2010 14:07:31 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: =?UTF-8?B?IkluZy4gRGFuaWVsIFJvenNuecOzIg==?= <daniel@rozsnyo.com>,
       Milan Broz <mbroz@redhat.com>, Marti Raudsepp <marti@juffo.org>,
       linux-kernel@vger.kernel.org,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: bio too big - in nested raid setup
References: <4B5C963D.8040802@rozsnyo.com>	<5ec358371001250725l40b13060md880001c96be165f@mail.gmail.com>	<4B5DE2A9.4030500@redhat.com>	<20100128132812.2d01f211@notabene>	<4B6157DB.6080502@rozsnyo.com> <20100128215015.0e0ed3a8@notabene>
In-Reply-To: <20100128215015.0e0ed3a8@notabene>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2010 12:50 PM, Neil Brown wrote:
> 
> Both raid0 and linear register a 'bvec_mergeable' function (or whatever it is
> called today).
> This allows for the fact that these devices have restrictions that cannot be
> expressed simply with request sizes.  In particular they only handle requests
> that don't cross a chunk boundary.
> 
> As raid1 never calls the bvec_mergeable function of it's components (it would
> be very hard to get that to work reliably, maybe impossible), it treats any
> device with a bvec_mergeable function as though the max_sectors were one page.
> This is because the interface guarantees that a one page request will always
> be handled.
> 

I'm also guilty of doing some mirror work, in exofs, over osd objects.

I was thinking about that reliability problem with mirrors, also related
to that infamous problem of coping the mirrored buffers so they do not
change while writing at the page cache level.

So what if we don't fight it? what if we just keep a journal of the mirror
unbalanced state and do not page_uptodate until the mirror is finally balanced.
Only then pages can be dropped from the cache, and journal cleared.

(Balanced-mirror-page is when a page has participated in an IO to all devices
 without being marked dirty from the get-go to the completion of IO)

I think Trond's last work with adding that un_updated-but-committed state to
pages can facilitate in doing that, though I do understand that it is a major
conceptual change to the the VFS-BLOCKS relationship in letting the block devices
participate in the pages state machine (And md keeping a journal). Sigh

??
Boaz
