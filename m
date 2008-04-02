Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYDBR6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYDBR6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 13:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755824AbYDBR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 13:58:33 -0400
Received: from relay.gothnet.se ([82.193.160.251]:1748 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754360AbYDBR6c convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 13:58:32 -0400
Message-ID: <47F3C90E.2020208@tungstengraphics.com>
Date: Wed, 02 Apr 2008 19:57:34 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <87myof8ief.fsf@basil.nowhere.org> <47F098E8.1050605@tungstengraphics.com> <20080331083816.GC29105@one.firstfloor.org> <47F0A988.7010707@tungstengraphics.com> <20080331091829.GD29105@one.firstfloor.org> <47F0C6C2.2000004@tungstengraphics.com> <47F10C62.7040500@linux.intel.com> <47F11443.7050302@tungstengraphics.com> <47F11616.3020403@linux.intel.com> <47F11ED3.40803@tungstengraphics.com> <47F2A202.1040900@linux.intel.com> <47F2A948.5070108@tungstengraphics.com> <47F2B788.1030101@linux.intel.com> <47F32816.4060806@tungstengraphics.com> <47F3294E.8090805@linux.intel.com> <47F32EDD.1080306@tungstengraphics.com> <47F391BD.1060306@linux.intel.com>
In-Reply-To: <47F391BD.1060306@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Thomas Hellström wrote:
>
> > to fix the long standing uc/wc aliasing issue, provided we
>
> I'm not opposed to a real fix. I am opposed to a bad hack.
>
Great. So a real clean fix involves setting all "default" kernel 
mappings either to WC (which will require PAT) or
Unmapped, for a pool of pages used in the graphics tables.

To reduce the number of attribute changes for mappings that are 
frequently switched, and also to reduce the number of clflushes, and to 
avoid waiting for upcoming wc versions of set_memory_xx, I have a strong 
preference for unmapping the pages.

Now is where I need some guidance, because interface design is not my 
strong side. I see three possible ways to do this.

1) Use set_memory_np(). Not desirable since we want to be able to use 
that function on a single mapping, and not imply other semantics.
2) Have the driver try to find out which "default" mappings the kernel 
has set up on a page and call set_memory_np() on each one of them. This 
seems very fragile and ugly even to me.
3) Have code in x86/pageattr.c decide which "default" mappings are 
present on the given pages and set them all as non-present.
In fact, there is already such a function in pageattr.c:

kernel_map_pages(struct page *pages, int numpages, bool enable);

But it's for debugging purposes only, could we use and export a variant 
of this?

I guess I need a hint as to what's considered allowable here, to avoid 
spending a lot of time on something that will in the end get rejected 
anyway.

Thanks,

Thomas





