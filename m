Return-Path: <linux-kernel-owner+w=401wt.eu-S1751631AbZHKCFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbZHKCFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 22:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbZHKCFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 22:05:11 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:51923 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZHKCFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 22:05:10 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=n734oir6eZo1qU3a57sL7A==:17 a=N1KCJpQk7IG-uDJ-GP0A:9
 a=GwBftpk7chjxnVzMkb4A:7 a=Jys806Jxcy5x81geuWl-qrrMT3cA:4
Message-ID: <a9c5028086c7f5f0e245853b9065e187.squirrel@ubb.ca>
Date: Mon, 10 Aug 2009 21:05:09 -0500
Subject: case-duplicated filenames
From: "Tony Mantler" <nicoya@ubb.ca>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A co-worker reminded me this afternoon that the linux source tree does not
get along well with case-insensitive filesystems. Ever the curious and
bored sort, and in the middle of an sqlite bender, I decided to cook up a
quick script to find exactly what files those are.

The results (in lowercase) are as follows:
linux-source-2.6.30/include/linux/netfilter/xt_mark.h
linux-source-2.6.30/include/linux/netfilter/xt_connmark.h
linux-source-2.6.30/include/linux/netfilter/xt_dscp.h
linux-source-2.6.30/include/linux/netfilter/xt_rateest.h
linux-source-2.6.30/include/linux/netfilter/xt_tcpmss.h
linux-source-2.6.30/include/linux/netfilter_ipv6/ip6t_mark.h
linux-source-2.6.30/include/linux/netfilter_ipv6/ip6t_hl.h
linux-source-2.6.30/include/linux/netfilter_ipv4/ipt_ttl.h
linux-source-2.6.30/include/linux/netfilter_ipv4/ipt_tos.h
linux-source-2.6.30/include/linux/netfilter_ipv4/ipt_ecn.h
linux-source-2.6.30/include/linux/netfilter_ipv4/ipt_connmark.h
linux-source-2.6.30/include/linux/netfilter_ipv4/ipt_dscp.h
linux-source-2.6.30/include/linux/netfilter_ipv4/ipt_tcpmss.h
linux-source-2.6.30/include/linux/netfilter_ipv4/ipt_mark.h
linux-source-2.6.30/net/netfilter/xt_tcpmss.c
linux-source-2.6.30/net/netfilter/xt_connmark.c
linux-source-2.6.30/net/netfilter/xt_mark.c
linux-source-2.6.30/net/netfilter/xt_dscp.c
linux-source-2.6.30/net/netfilter/xt_rateest.c
linux-source-2.6.30/net/netfilter/xt_hl.c
linux-source-2.6.30/net/ipv4/netfilter/ipt_ecn.c
linux-source-2.6.30/documentation/io-mapping.txt

And the script, if you'd like to run it yourself, is as follows (hereby
released GPL2):
#!/bin/bash

#set -x

SQLITE3=`which sqlite3`
DBNAME=filenames.db
SQLFILE=filenames.sql

DIRECTORY=linux-source-2.6.30

$SQLITE3 $DBNAME "CREATE TABLE filenames ( id INTEGER PRIMARY KEY, name
TEXT );"

echo "PRAGMA synchronous=OFF;" >$SQLFILE
echo "BEGIN TRANSACTION;" >>$SQLFILE
find $DIRECTORY | tr  '[:upper:]' '[:lower:]' | sed 's/^\(.*\)/INSERT INTO
filenames (name) VALUES ("\1");/' >>$SQLFILE
echo "COMMIT;" >>$SQLFILE

$SQLITE3 $DBNAME <$SQLFILE

$SQLITE3 $DBNAME "SELECT a.name FROM filenames a, filenames b WHERE a.name
== b.name AND a.id < b.id;"

rm $SQLFILE
rm $DBNAME

