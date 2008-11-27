Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbYK0ONW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbYK0ONW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 09:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbYK0ONO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 09:13:14 -0500
Received: from yx-out-2324.google.com ([74.125.44.30]:5138 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYK0ONN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 09:13:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=ccS9h+IDbzHpifLQj44+pWYlq8lLIyd2/2XcY6olKoLzspjMbETyNI94SrXZHVK2vr
         lyr6k15Nba02uBTaB4Otr3b3oH4MjQqZRj2j2dQ7BouzfHWz4xIaxfsEgbHxv3eeNmR0
         aLn/g0N4cxQjvFhK99W6UCQqJ0DpmwwwTIuyw=
Message-ID: <84144f020811270613t3f0258ddxac52abb9a447bf40@mail.gmail.com>
Date: Thu, 27 Nov 2008 16:13:11 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Hugh Dickins" <hugh@veritas.com>
Subject: Re: 2.6.28-rc6-git1 -- BUG: unable to handle kernel paging request at ffff8800be8b0019
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Miles Lane" <miles.lane@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <cl@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Tejun Heo" <htejun@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Vegard Nossum" <vegard.nossum@gmail.com>
In-Reply-To: <Pine.LNX.4.64.0811271349040.21910@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a44ae5cd0811250850g725a5a5nd7d93a23ffd2fce6@mail.gmail.com>
	 <200811270026.37941.rjw@sisk.pl>
	 <84144f020811270537l3798b2f5ka63caacbee43b075@mail.gmail.com>
	 <Pine.LNX.4.64.0811271349040.21910@blonde.site>
X-Google-Sender-Auth: 4b693130d7a34a89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hugh,

(I'm adding Vegard to the cc as he pointed out the same thing.)

On Thu, Nov 27, 2008 at 3:54 PM, Hugh Dickins <hugh@veritas.com> wrote:
> I think you're looking at a 2.6.28-rc5 sprint_symbol() there:
> the world has moved on since those days.  I changed it to use the
> supplied "buffer" instead of local "namebuf" in 2.6.28-rc6, so we
> have to wonder if my patch is to blame - though I don't see it.
>
> Sorry, I'm eating lunch then about to go out for a couple of hours:
> can't look into it now, but maybe this info will help you to make
> better sense of what's going on.

Oh, right. I think I see where this is going. The buffer is coming
from sysfs and is PAGE_SIZE long. In SLUB, we do check for overflows
but list_locations() allows us to get as close as 100 bytes bytes from
the edge of the page. Unfortunately, kallsyms_lookup() does:

  const char *kallsyms_lookup(unsigned long addr,
                              unsigned long *symbolsize,
                              unsigned long *offset,
                              char **modname, char *namebuf)
  {
          namebuf[KSYM_NAME_LEN - 1] = 0;
          namebuf[0] = 0;

where KSYM_NAME_LEN is 128 which will tip us over the page edge
potentially triggering an oops. The proper fix is probably to pass a
length of namebuf to kallsyms_lookup() but it's probably best to
revert the patch this late in the release cycle?

                        Pekka
