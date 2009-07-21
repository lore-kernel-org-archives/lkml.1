Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbZGUKrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbZGUKrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZGUKrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:47:45 -0400
Received: from bu3sch.de ([62.75.166.246]:60625 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194AbZGUKro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:47:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] thinkpad-acpi: Avoid heap buffer overrun
Date: Tue, 21 Jul 2009 12:47:09 +0200
User-Agent: KMail/1.9.9
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <200907211216.18135.mb@bu3sch.de> <200907211217.47484.mb@bu3sch.de>
In-Reply-To: <200907211217.47484.mb@bu3sch.de>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907211247.09244.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 July 2009 12:17:47 Michael Buesch wrote:
> On Tuesday 21 July 2009 12:16:17 Michael Buesch wrote:
> > Avoid a heap buffer overrun triggered by an integer overflow of the userspace
> > controlled "count" variable.
> > If userspace passes in a "count" of (size_t)-1l, the kmalloc size will overflow
> > to ((size_t)-1l + 2) = 1, so only one byte will be allocated. However, copy_from_user()
> > will attempt to copy 0xFFFFFFFF (or 0xFFFFFFFFFFFFFFFF on 64bit) bytes to the buffer.
> > 
> > A possible testcase could look like this:
> > 
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <unistd.h>
> > #include <fcntl.h>
> > 
> > int main(int argc, char **argv)
> > {
> > 	int fd;
> > 	char c;
> > 
> > 	if (argc != 2) {
> > 		printf("Usage: %s /proc/acpi/ibm/filename\n", argv[0]);
> > 		return 1;
> > 	}
> > 	fd = open(argv[1], O_RDWR);
> > 	if (fd < 0) {
> > 		printf("Could not open proc file\n");
> > 		return 1;
> > 	}
> > 	write(fd, &c, (size_t)-1l);
> > }

Hm, I just realized that for it to crash the source buffer must be big enough.
&c is on the stack. Maybe that's big enough to overrun the kmalloc()acted chunk
(there may be padding beyond the 1 byte). If it's not big enough, one must
malloc()ate a big buffer and pass it to write() instead.

This is all theoretical stuff, because I can't test it, but it looks sane. :)

> > We avoid the integer overrun by putting an arbitrary limit on the count.
> > PAGE_SIZE sounds like a sane limit.
> > 
> > Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> Whoops, forgot
> Cc: stable@kernel.org



-- 
Greetings, Michael.
