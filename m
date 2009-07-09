Return-Path: <linux-kernel-owner+w=401wt.eu-S1760724AbZGIPWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724AbZGIPWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 11:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbZGIPWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 11:22:24 -0400
Received: from mail-gx0-f226.google.com ([209.85.217.226]:36097 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051AbZGIPWX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 11:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=G24PTaQe7y8M7KGDcByGWCChnnuZF98P1GblnwO/nchC/inz73D0VSLdIso/UB7SdW
         Qhc14tybz0saTdwJbilPtjI9I/AQCyLnk8tfKavH29AehhZk2TMLMRGhQsj8YWmGFSI6
         BshO7x6rMujSYtrFJSHpTLzcLcMt6N3eFV1lE=
MIME-Version: 1.0
In-Reply-To: <24005.1247134018@redhat.com>
References: <8bd0f97a0907090104h5d4984dfkbeb82616a01128c8@mail.gmail.com> 
	<24005.1247134018@redhat.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 9 Jul 2009 11:22:01 -0400
Message-ID: <8bd0f97a0907090822g1533e9dt97c3f29ccaf4945b@mail.gmail.com>
Subject: Re: truncate on MAP_SHARED files in ramfs filesystems on no-mmu
To: David Howells <dhowells@redhat.com>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 9, 2009 at 06:06, David Howells wrote:
> Mike Frysinger wrote:
>> reviewing LTP tests shows mmap09 failing.  this test creates a file of
>> a certain length, opens it and creates a shared mapping, and then
>> tries various truncate tests:
>> truncate to a smaller size
>> truncate to a larger size
>> truncate to size 0
>>
>> the first and last fail on no-mmu due to
>> file-nommu.c:ramfs_nommu_resize() rejecting attempts to shrink on a
>> shared mapping:
>
> Yes.  That's exactly right.
>
>> my question is why?  if an application maps a fd with MAP_SHARED,
>> truncates it, and then it or someone else who has that fd mapped tries
>> to access the now-invalid tail end, that is a bug in the application.
>> i dont see why we should be protecting users here from their own buggy
>> code ?
>
> This is protecting the kernel as much as the user.  There's no MMU to enforce
> denial of access on the pages that truncate returns to the system.

you dont need a MMU (virtual memory) to protect against it.  you only
need a MPU which some systems have.

> This doesn't only protect the process with a mapping on that file against its
> own truncate, but also other processes that have made mappings against that
> file.

and those too are broken

> Whilst you can argue it either way, you need a better reason to change this
> than it causes some LTP failures.  You cannot expect all the MM-related LTP
> tests to work against a NOMMU system.

crappy programming is likely to crash regardless of standard functions
we attempt to disable in the kernel.  this isnt a virtual memory issue
at all, it's memory protection.

> Doing it this way also makes things simpler in the kernel and makes the system
> more robust.

really ?  looks like the kernel is a lot more complicated to me.  the
fix here would be to delete a whole bunch of code.

> If a process shared mmaps a file and then wants to truncate it, it can always
> munmap the excess first.

sure, we could go around changing a whole bunch of things specific to
no-mmu, but that's kind of the wrong way to go.  applications shouldnt
need to know they're running with different MMU features available.
-mike
