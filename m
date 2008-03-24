Return-Path: <linux-kernel-owner+w=401wt.eu-S1761506AbYCXSVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761506AbYCXSVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 14:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbYCXSVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 14:21:09 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55001 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753220AbYCXSVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 14:21:08 -0400
Date: Mon, 24 Mar 2008 13:21:04 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/8] - Support for UV platform
Message-ID: <20080324182104.GA27968@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series of patches add x86_64 support for the SGI "UV" platform.
Most of the changes are related to support for larger apic IDs and
new chipset hardware that is used for sending IPIs, etc.

UV supports really big systems. So big, in fact, that the APICID register
does not contain enough bits to contain an APICID that is unique across all
cpus.

The UV BIOS supports 3 APICID modes:

        - legacy mode. This mode uses the old APIC mode where
          APICID is in bits [31:24] of the APICID register.

        - x2apic mode. This mode is whitebox-compatible. APICIDs
          are unique across all cpus. Standard x2apic APIC operations
          (Intel-defined) can be used for IPIs. The node identifier
          fits within the Intel-defined portion of the APICID register.
	  (Note: most of the code to support x2apic mode will come in
	  a separate patch).

        - x2apic-uv mode. In this mode, the APICIDs on each node have
          unique IDs, but IDs on different node are not unique. For example,
          if each mode has 32 cpus, the APICIDs on each node might be
          0 - 31. Every node has the same set of IDs.
          The UV hub is used to route IPIs/interrupts to the correct node.
          Traditional APIC IPI operations WILL NOT WORK.


In x2apic-uv mode, the ACPI tables all contain a full unique ID:
        nnnnnnnnnnlc0cch
                n = unique node number
                l = socket number on board
                c = core
                h = hyperthread

Only the "c0cch" bits are written to the APICID register. The remaining bits are
supplied by having the get_apic_id() function "OR" the extra bits into the value
read from the APICID register.

The x2apic-uv mode is recognized by <oem_id> & <oem_table_id> fields of
the MADT table.

