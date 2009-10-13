Return-Path: <linux-kernel-owner+w=401wt.eu-S1759255AbZJMJBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255AbZJMJBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:01:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758997AbZJMJBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:01:41 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:50875 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996AbZJMJBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:01:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Vdgywb3Y2gTvz+G4bqIXHsS+6oArMoseWBTWFTS4wYzCW2gp/0X4vVW2RGi73FSkD4
         +cr+/dNh7Nz5HfrS3Cl98A8H++obdR324zPEl7ToyPuEsUlJze1QNUTqmfktY8V6diVq
         CLHZ9WGAZjtrEvTOLIXg5Q4iE1vSyGMigcHcc=
MIME-Version: 1.0
Date: Tue, 13 Oct 2009 02:01:03 -0700
Message-ID: <9a158e2e0910130201m1f63a7d7h15c8a7445a36cd51@mail.gmail.com>
Subject: iommu-helper.c -> find_next_zero_area errors
From: Kyle Hubert <khubert@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function find_next_zero_area in iommu-helper.c, I think there
are two small issues. For one, it appears the conditionals after
find_next_zero_bit will cause failures when there is still room in the
IOMMU area. Here is the code in question:

  15again:
  16        index = find_next_zero_bit(map, size, start);
  17
  18        /* Align allocation */
  19        index = (index + align_mask) & ~align_mask;
  20
  21        end = index + nr;
  22        if (end >= size)
  23                return -1;
  24        for (i = index; i < end; i++) {
  25                if (test_bit(i, map)) {
  26                        start = i+1;
  27                        goto again;
  28                }
  29        }
  30        return index;

On line 16, we get the index with the next zero bit in the bit-field.
Then the "end" value is compared against size on line 22. By testing
for >=, an allocation of 64 elements in a 64 bit bit-field would
result in (0 + 64) >= 64. This means it would return -1, or, no space.
Anything that butts against the end of the area will fail.

Then continuing on to line 24, we see the for loop starting at the
"index" value. Index was just returned by find_next_zero_bit, so we
know it's zero, and there is no reason to call test_bit on it. This is
just a spurious execution of the loop.

I would think you would want it to look like this:

-       if (end >= size)
+       if (end > size)
               return -1;
-       for (i = index; i < end; i++) {
+       for (i = index + 1; i < end; i++) {

Thanks,

-Kyle Hubert
