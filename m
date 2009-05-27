Return-Path: <linux-kernel-owner+w=401wt.eu-S1757659AbZE0FIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659AbZE0FIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 01:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757034AbZE0FIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 01:08:12 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:34769 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbZE0FIL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 01:08:11 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: Net: ucc_geth ethernet driver optimization space
Date: Wed, 27 May 2009 13:08:07 +0800
Message-ID: <D7CCA83BB0796C49BC0BB53B6AB1208934920A@zch01exm21.fsl.freescale.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Net: ucc_geth ethernet driver optimization space
Thread-Index: AcneiR9I1LuMRrYGSMaTMEHfoMmW8Q==
From: "Liu Dave-R63238" <DaveLiu@freescale.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <linuxppc-dev@ozlabs.org>
X-Brightmail-Tracker: AAAAAQAAAWE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys,

The ucc_geth ethernet driver have dozens of strong sync read/write
operation, such as in_be32/16/8, out_be32/16/8.

all of them is sync read/write, it is very expensive for performance.

For the critical patch, we can remove some unnecessary in_be(x),
out_be(x) with normal memory operation, and keep some necessary
memory barrier.

eg: BD access in the interrupt handler and start_xmit.

The BD operation only need the memory barrier between length/buffer
and status.

struct buffer descriptor {
	u16 status;
	u16 length;
	u32 buffer;
} __attribute__ ((packed));

struct buffer descriptor *BD;

BD->length = xxxx;
BD->buffer = yyyy;
wmb();
BD->status = zzzz;

For powerpc, eieio is enough for 60x, mbar 1 is enough for e500.
Of couse, also need the memory clobber to avoid the compiler
reorder between them.

Thanks, Dave


