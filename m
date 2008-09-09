Return-Path: <linux-kernel-owner+w=401wt.eu-S1754022AbYIIDFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022AbYIIDFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 23:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYIIDFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 23:05:10 -0400
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:41015 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751966AbYIIDFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 23:05:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Message-Id;
  b=FyaV+NW+H6O8UZ5wBzZP6g9DCvzVYpuyt12bRw3qqcs/Zp1iMHtVSF1kWb98MjXQmW1Z0Pr7xwEVg7oMf9q7P4otI7EFI17JAc9RRdKLDuqMzzE7+OxLlzIIQdAIQo/E8x91Cqbvz7kMzccFKD5+F1LSmP6BIW0KbVrhvBX3gIA=  ;
X-YMail-OSG: t_NM3JcVM1kZeaM1BXoQuVZSGUlNP5d19aP3d9GDPDjQ1tm6OJW8Jcu18r0VTF8orQkkLL1A49euxcearIIS45yh_F0QR4nadT1eI6JnLOMWfHfrzY1Nna1nDrJmMK5q8ac-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: Re: 2.6.27-rc5-mm1: 3 WARN_ON dumps during boot (acpi + vmap_pte_range)
Date: Tue, 9 Sep 2008 13:04:47 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@linux.ie>, Rusty Russell <rusty@rustcorp.com.au>
References: <20080906084558.dff614d4.krzysztof.h1@poczta.fm> <200809081937.16427.nickpiggin@yahoo.com.au> <20080908195208.773ecadb.krzysztof.h1@poczta.fm>
In-Reply-To: <20080908195208.773ecadb.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_PfexIaD1J9KQr+b"
Message-Id: <200809091304.47769.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_PfexIaD1J9KQr+b
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 09 September 2008 03:52, Krzysztof Helt wrote:

> alloc_vmap_area within(e07f0000-fffb7000) size=801000
> returns=(e0880000-e1081000)
> alloc_vmap_area within(e07f0000-fffb7000) size=2000
> returns=(e07f0000-e07f2000)
> alloc_vmap_area within(e07f0000-fffb7000) size=2000
> returns=(e0822000-e0824000) 
> vunmap_page_range (e07f0000-e07f2000 size=2000)
> free_vmap_area (e07f0000-e07f2000 size=2000)

> alloc_vmap_area within(e07f0000-fffb7000) size=5000
> returns=(e07f0000-e07f5000)
> ------------[ cut here ]------------ 
> WARNING: at mm/vmalloc.c:40 check_pte_range+0x83/0x90()

Thanks for that, it clearly shows the virtual address allocator
is allowing an overlapping allocation after a vm_unmap_aliases()
call. Unfortunately, my "random" test case happened not to
trigger that... I should have paid more attention to edge cases
rather than just random testing.

Anyway, I hope this fix should solve the problem for you? (it
fixes it here)

--Boundary-00=_PfexIaD1J9KQr+b
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="vmap-new-infrastructure-fix2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="vmap-new-infrastructure-fix2.patch"

Index: linux-2.6/mm/vmalloc.c
===================================================================
--- linux-2.6.orig/mm/vmalloc.c
+++ linux-2.6/mm/vmalloc.c
@@ -321,7 +321,7 @@ retry:
 			struct vmap_area *tmp;
 			tmp = rb_entry(n, struct vmap_area, rb_node);
 			if (tmp->va_end >= addr) {
-				if (!first && tmp->va_start <= addr)
+				if (!first && tmp->va_start < addr + size)
 					first = tmp;
 				n = n->rb_left;
 			} else {

--Boundary-00=_PfexIaD1J9KQr+b--
