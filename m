Return-Path: <linux-kernel-owner+w=401wt.eu-S1760037AbZADRbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760037AbZADRbX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 12:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759189AbZADRaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 12:30:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:54066 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759457AbZADRaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 12:30:17 -0500
Date: Sun, 4 Jan 2009 09:24:30 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@elte.hu, fweisbec@gmail.com,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-acpi@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 0/4] Fastboot revisited: Asynchronous function calls
Message-ID: <20090104092430.7ffd2c41@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series is based on Linus' original reaction to some of the
fastboot patches which introduced an "asynchronous initcall level".
Linus did not like the initcall level approach much, and wanted a much
more finegrained kind of thing.

This patch series introduces asynchronous function calls.
The goal is still the same (boot faster), the method is entirely
different.

Asynchronous function calls allow drivers and subsystems to do
operations asynchronously, while providing a mechanism to serialize
the asynchronous operations at "externally visible" locations, such as
device number registrations. 

As such, this approach is NOT a "full parallel kernel init".
For one, it keeps device numbers stable. For another, it's very much
opt-in for any code using this.

Rather, it is more comparable to an out-of-order cpu, where computations
are done asynchronously, but are retired in program order.

This series first introduces the infrastructure in patch 1,
and then adds users of this infrastructure (scsi in patch2, libata in
patch 3 and acpi in patch 4).

To see this working, I uploaded a "before" and "after" kernel bootchart
for one of my testboxes at

http://www.fenrus.org/linux/before.svg
http://www.fenrus.org/linux/after.svg

As you can see with inkscape (or gimp or any other svg viewer), there
is still room for doing more things in parallel, but the 3 example usage
patches are a big win already.


One comment about the API:
Originally I had functionality in mind where the caller of
async_schedule() could get back the cookie value of the scheduled task.
However I had no users of this, so I removed the code to do this. If
someone finds a place where this is useful we can easily add this back.

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
