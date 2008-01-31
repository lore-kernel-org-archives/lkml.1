Return-Path: <linux-kernel-owner+w=401wt.eu-S933993AbYAaQrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933993AbYAaQrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 11:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932816AbYAaQrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 11:47:00 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:31858 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765591AbYAaQq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 11:46:58 -0500
X-IronPort-AV: E=Sophos;i="4.25,286,1199682000"; 
   d="scan'208";a="61315735"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: managing kallsyms_addresses
Date: Thu, 31 Jan 2008 11:48:18 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311148.18859.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 31 Jan 2008 16:46:56.0899 (UTC) FILETIME=[E4226D30:01C86428]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel needs to find out what symbol is at a specific address, it 
uses kallsyms_lookup() This seems to work pretty well - almost.

The problem is today, we don't to remove the symbols from the init section 
when the init section is freed. There is invalid data in kallsyms_addresses.

The problem I have been experiencing - If you have a module get loaded into a 
location which was init, then kallsyms_lookup()  can return init labels, 
rather than the module labels. (since it looks up kernel labels before module 
labels).

What happens is if there is a OOPS in the module, the labels from the OOPS can 
point to init code (which doesn't exist), which confuses the heck out of 
users and developers... 

There would be two solutions:
 - when freeing the init section, remove all the init labels from the 
kallsyms_addresses, and resort/pack it.
 - if the init section is unloaded, have is_kernel_inittext always return 0.

I assume that similar things need to be handled for module init too, but I 
have not run into that yet.

Thoughts?
