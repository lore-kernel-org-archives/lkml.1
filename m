Return-Path: <linux-kernel-owner+w=401wt.eu-S1758059AbYDQI5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059AbYDQI5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbYDQI5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:57:16 -0400
Received: from web36702.mail.mud.yahoo.com ([209.191.85.36]:34398 "HELO
	web36702.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758263AbYDQI5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:57:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 17 Apr 2008 04:57:14 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=qEOyyMPIU9j2m0kdFANiwQWv9RYWDjM5BCE/FcEusx8Z4QsIw6NJspXvbKZGD1N1VLa/qfggAfBgCG7zNbFnVntQX2W0nVkeM5DDNMWz7SBskGtAsiN7x6OqWB4Hu/bTYOEcCMwp7tF1nmIw8QEnmYaLpwgvGLOgOHh5BPpFgn4=;
X-YMail-OSG: wdi4towVM1lDQCf2l83T8GlZBiTlHY1qNse5DQXlYhJiNVbTBCp0BQ7PqoVWxXGXhbh7e4xGaLZFwygG5OXukEQbeSNfwbQ-
Date: Thu, 17 Apr 2008 01:50:33 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Smartmedia/xd card support - request for comments
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <466372.69780.qm@web36702.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've implemented, with generous help from JMicron, a native support for Smartmedia/xD picture card
media. Currently, only JMicron backend is available, but TI expressed some interest in this too,
so TI Flashmedia backend may soon follow.

Smartmedia cards are quite akin to the dumb flash chips, but they have their quirks that put them
aside as a separate media type.

I thought of the following merge structure:

include/linux/
    flash_bd.h
    xd_card.h

drivers/xd_card/
    xd_card_blk.c - protocol implementation
    xd_card_ecc.c - software version of Smartmedia ecc algorithm
    jmb38x_xd.c   - JMicron backend

lib/
    flash_bd.c    - generic FTL implementation

A few more words about flash_bd component. Legacy MemoryStick and SmartMedia cards require direct
management of flash memory. I studied the mtd layer, but found it to be not very helpful, so I
wrote my own FTL module.

Its requirements were:
1. Subsystem independent. For a given byte range it will produce a sequence of generic opcodes
needed to read or write such a range to/off the flash memory, assuming page grained access. This
is used not only for block device operations, but also for metadata retrieval.
2. No FTL related metadata is stored to the flash (as nothing can be assumed about other
readers/writers in interchange media formats).

My FTL implements random block replacement policy, as there's no spec-mandated way to maintain
wear counts on Smartmedia or Memorystick. It also supports block allocation zoning, as required by
these formats.

Current version will always issue whole block writes (no individual page programming). I,in fact,
implemented a version which tracks partially filled blocks, but experiments with some Olympus xd
cards triggered a lot of funny hardware problems with this, and then, it appeared that latest
version of xd card spec specifically disallows partial block writes.

MemoryStick spec does allow individual page writes, but so did an older version of xd card spec.
Given this, I decided to start with simpler version of FTL for now and replace it with a more
complex one if need arises.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
