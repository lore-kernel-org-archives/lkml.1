Return-Path: <linux-kernel-owner+w=401wt.eu-S1754848AbYLIQ7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbYLIQ7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 11:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751419AbYLIQ7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 11:59:46 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:41587 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbYLIQ7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:59:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=tWYnnxk+awDeJEK9L1IDYMjTfC/rPdBOtdwwtI6D0MUdVdRuNfnXoSVfWWi3yLM14C
         z+5b9uhbTCg0DIHIKJclGiUd80sthBeiiHOOjGjddMR5LcSo1jlHOCnUp5uRZ5RrquYp
         cgPndZCvsCqZ4vgPVlPDtZHAFq79wAjy6xOhk=
Message-ID: <493EA286.7080500@gmail.com>
Date: Tue, 09 Dec 2008 17:53:26 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/33] Make static
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches make things static, found by sparse. They are only used in
the file where they are declared.

I first compiled the kernel using sparse. and piped output to
../logs/make_yes_log_20081203155529

Then I used the script below, but made some manual changes as well. I tested
changes with checkpatch, have built it successfully with allnoconfig,
allmodconfig and allyesconfig.

Thanks,

Roel

Q="[^[:alnum:]_]"
s="[[:space:]]+"
V="[A-Za-z_]+[A-Za-z0-9_]*"

grep "Should it be static\?" ../logs/make_yes_log_20081203155529 |
   sed -rn "s/^([^:]*):([^:]*):.*'($V)'.*$/\1 \2 \3/p" | while read f n v; do
 echo "---[ v $f:$n $v ]---"
 f2="$(git grep -l -E "(^|$Q)$v($Q|$)")"
 z=$(echo "$f2" | wc -l)
 if [ $z -eq 1 ]; then
   echo "$v can be static: v $f:$n"
   sed -r -i "${n}s/^(static$S)*(.*)$/static \2/" "$f"
 elif [ $z -lt 5 ]; then
   grep -E -n "(^|$Q)$v($Q|$)" $(echo $f2 | tr "\n" " ");
   echo "if this can be static then apply:"
   echo "sed -r -i \"${n}s/^(static$S)*(.*)$/static \2/\" \"$f\"";
 fi
done | less
