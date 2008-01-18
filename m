Return-Path: <linux-kernel-owner+w=401wt.eu-S1760856AbYARQok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760856AbYARQok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:44:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759743AbYARQob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:44:31 -0500
Received: from saeurebad.de ([85.214.36.134]:50017 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762193AbYARQoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:44:19 -0500
From: Johannes Weiner <hannes@saeurebad.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 42c9c06bec x86: ACPI: use ioremap_early() instead of __va()/__pa()
Date: Fri, 18 Jan 2008 17:45:12 +0100
Message-ID: <87r6gft753.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

with the commit

	42c9c06bec2f48002d5b6573c8700461120070a9
	x86: ACPI: use ioremap_early() instead of __va()/__pa()

you made __acpi_map_table(), which is non-__init, call early_ioremap()
which is __init on 64bit (init_64.c) but non-__init on 32bit
(ioremap_32.c).  This results in section mismatches on 32bit.

The version I have here is v2.6.24-rc8-725-g0f80375.

I had a look into ioremap_32.c and as it seems no __init function should
be called at all in the callpath down from early_ioremap() after the
__init sections are tossed out; but it is decided during runtime with
the check of after_paging_init and so the illegal references still
exist.

What is the solution here?  I have not a real clue of the code, but
perhaps we can make early_ioremap REALLY __init only and use something
different from non-init code?

	Hannes
