Return-Path: <linux-kernel-owner+w=401wt.eu-S934033AbYBHJQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934033AbYBHJQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 04:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760977AbYBHJQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 04:16:37 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:50681
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757861AbYBHJQg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 04:16:36 -0500
Message-Id: <47AC2C1F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 08 Feb 2008 09:17:03 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Cc: "Chuck Ebbert" <cebbert@redhat.com>, <linux-kernel@vger.kernel.org>,
       "Al Viro" <viro@ZenIV.linux.org.uk>
Subject: Re: section breakage on ppc64 (aka __devinitconst is broken by
	design)
References: <20080203130844.GS27894@ZenIV.linux.org.uk>
 <47AB4F0E.3050907@redhat.com> <20080207185409.GA21145@uranus.ravnborg.org>
 <47AC1D63.76E4.0078.0@novell.com>
 <20080208084744.GA27120@uranus.ravnborg.org>
In-Reply-To: <20080208084744.GA27120@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Al posted the following:
>====================================================================
>; cat >a.c <<'EOF'
>const char foo[] __attribute__ ((__section__(".blah"))) = "";
>const char * const bar __attribute__((__section__(".blah"))) = "";
>EOF
>; gcc -m32 -S a.c
>; gcc -m64 -S a.c
>a.c:2: error: bar causes a section type conflict
>;
>
>That's 4.1.2 on ppc.  What happens is that the second declaration
>wants to make .blah writable.  We actually trigger that in ppc64
>builds on drivers/net/natsemi.c.
>
>Note that on ppc64 without explicit sections you have the second one land in
>.data.rel.ro.local, which is "aw",progbits.
>====================================================================
>
>Se we see that despite being marked as const the the section
>is in one case marked as read-only by gcc and in another case the section
>is marked as rw.

Oh, indeed, this kind of a construct also fails for ia64 on existing gcc-s.

>And this is with the gcc version that is in use today and which
>we must support.
>Thats why I think we have to loose the constification that is going on
>or we should loose the section attribute on the data.

That is very unfortunate, but is then a good reason to fold the
'const' into the __devinitconst definition as I originally suggested (and
perhaps that's the reason why I didn't have problems with my version
of the patch on ia64) - that way, those architectures that can't tolerate
it could have __devinitconst continue to resolve to __devinitdata,
resulting in traditional section allocation, while targets like x86 can still
benefit from the constification.

Apart from that we may want to approach the gcc folks to allow a way
to override this 'optimization for the kernel (or more generally for
statically linked executables).

Jan

