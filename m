Return-Path: <linux-kernel-owner+w=401wt.eu-S1757496AbZDNRXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496AbZDNRXl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 13:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZDNRXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 13:23:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:55535 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755968AbZDNRX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 13:23:29 -0400
Subject: checkpoint/restart: taking refcounts on kernel objects
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org, xemul@parallels.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090414170419.GD27923@x200.localdomain>
References: <20090410023539.GK27788@x200.localdomain>
	 <20090413214701.GA24509@us.ibm.com>
	 <20090414152752.GC27461@x200.localdomain>
	 <20090414154139.GA8085@us.ibm.com>
	 <20090414170419.GD27923@x200.localdomain>
Content-Type: text/plain
Date: Tue, 14 Apr 2009 10:23:20 -0700
Message-Id: <1239729800.32604.92.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-14 at 21:04 +0400, Alexey Dobriyan wrote:
> > Right while I have opinions on some things in this list, I didn't
> > mean to imply positions on these items.  My question was:  are
> > there are differences you want to call out?
> 
> Sorry? "none needed" is relevant to only item 3. If tasks don't
> dissapear during checkpoint, why would netns dissapear.
> Taking refcount on checkpoint(2) is likely unneeded.
> 
> But it's low-level detail anyway.

I guess it is a matter of whether we consider a task that gets unfrozen
a kernel bug or not.  If we don't take refcounts and we do reference an
object that disappears, then we *certainly* have a kernel bug that can
crash the kernel.  If we take refcounts, we at least limit the ways in
which the kernel can crash when something screwy happens.

On the other hand, the objhash is a kinda weird way to do it.  Taking
and releasing arbitrary refcounts on arbitrary kernel objects one level
too much of abstraction for me.

Come to think of it...  In the pipe case, we're *guaranteed* to have
someone hold an extra refcount for us after we encounter the first side
of the pipe: the other side of the pipe.  If the other side isn't there,
then we didn't need to save the reference.  If it is there, it was
holding a refcount and we didn't need an extra one.

-- Dave

