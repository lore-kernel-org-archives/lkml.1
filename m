Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYFQP1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYFQP1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 11:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757982AbYFQP1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 11:27:00 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:61059 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757381AbYFQP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 11:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ZgZZPjCYfs0rBspK7Y82/d2u5tiwIuEUC5mD1XXuGRPzRh0xw4x/aAp+LqmR1qmjW6
         bStFFZXqhq84LB0EHZcXH+NWnb4tgXtDrUJC6qEc3yUsHzj1pmJ1uDM5RPkC2zLzKrlY
         abgbwdaOIhnoJ5rzlgxgklHp5Ao0OIDPXNipI=
Message-ID: <85e7c2fc0806170826r66ea6f52nccb1f5b3edf1eda@mail.gmail.com>
Date: Tue, 17 Jun 2008 23:26:56 +0800
From: "Bob Zhang" <zhanglinbao@gmail.com>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: Does anyone run AXFS in 2.4 version of kernel ? I am trying my best to apply AXFS patches into 2.4.18
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <85e7c2fc0806170757t66a1167m9683fd4ad1c36f71@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <85e7c2fc0805090919v613fb823m8dd979b8cd959889@mail.gmail.com>
	 <6934efce0805120923v636d2dbjb062d33fb861f5a2@mail.gmail.com>
	 <85e7c2fc0805131746k5284d66dj7cfac5f9138186e2@mail.gmail.com>
	 <6934efce0805131801s633a1692ha8914a76173c2c80@mail.gmail.com>
	 <85e7c2fc0805190842v6ee5f4f3jef7790b0fa459a21@mail.gmail.com>
	 <85e7c2fc0806160720v510a565id709ee782851169d@mail.gmail.com>
	 <85e7c2fc0806170757t66a1167m9683fd4ad1c36f71@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following is what I have known about AXFS implement .If I am not
right, please Jared Hulbert cto correct what I have said.


Honestly speaking , AXFS orgnization is pure complex , and no any
valuable document to help to understand the source code . if you want
to make clear what happned ,it is not easy .

I have spent over 2 days to read the mkfs.axfs.c , this is what I have known .
---
For axfs super block ,the best valuable infomation is some offset of regions ,
axfs image has many regions , such as node_type regions , node_index
regions,especially X
IP region,Compressed region and Byte Aligned region which are the most
important for us.

Important info is that once you have read the superblock into a buffer
head , you can get all the offset info of all regions. thus , you can
get the address of regions in the file image .
once you get the region structure , you can get the "region->fsoffset"
and "region->virt_addr" , the "region->fsoffset" present that the real
location region in the image .
For example , for XIP region , you can get all the pages of data
through "xip_region->fsoffset" . and then through node_index, you can
get responding pages.

Another key parameter is "virt_addr" ,

++++

First ,pages are of XIP or Compressed is decided by mkfs.axfs -i xml.txt
if no the xml.txt provided , mkfs.axfs should compress all the files
in the image by default.

in the main() of mkfs.axfs.c
the axfs will compute the number of files , there are some global
variables to record these .
in function named  parese_directory() it will generate many entries
reponding with these files ,and at last , it will call "is_xipfile()"
function to call "set_page_state" function to set some files and pages
to be XIP if these names occur in the xml file as parameter of
mkfs.axfs -i .

In fact , for XIP files and pages , axfs handling is simple , for
example , I want to set rootfs/init 's 0~4095 bytes to be XIP  ,the
length of block of data must be aligned with PAGE_SIZE .
you can set the
<chunk>
  <size>4096</size>
  <offset>0</offset>
</chunk>

In fact , the data of XIP and that of compressed will be stored
respectively different regions .
for example , a file size is large , you know ,for example ,3MB .
it will have many pages of data , only the XIP pages will be stored
into XIP region
node_index[node_count] = xip_rd.size/PAGE_SIZE . THIS INDEX is valid for XIP

For every page , it will have node_index. this node_index will be
added when parsing the root directory . that is also said that, every
page has its own unique index number . Future , in kernel ,the axfs
code will use it. the kernel axfs code will use some macros to get
detailed infomation about a page , for example , this page is of XIP
or Compressed .
