Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbXFUUst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbXFUUst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758838AbXFUUsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:48:37 -0400
Received: from wireless-243.media.mit.edu ([18.85.18.243]:44033 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758591AbXFUUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:48:35 -0400
X-Greylist: delayed 2228 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jun 2007 16:48:35 EDT
Date: Thu, 21 Jun 2007 16:11:35 -0400 (EDT)
From: "C. Scott Ananian" <cscott@laptop.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] update procfs-guide doc of read_func
Message-ID: <Pine.LNX.4.64.0706211608350.19379@localhost.localdomain>
X-GPG-FINGRPRINT: 6ED80418 - D62F 6DEB F5AC 91F7 7197  A212 8A62 ED98 6ED8 0418
X-GPG-FINGRPRINT: 85AD9EED - ADC0 4908 9167 DFD7  FA04 1AEE 09E8 44B0
X-GPG-PUBLIC_KEY: http://cscott.net/publickey.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The procfs-guide claims that 'the parameter start doesn't seem to be used 
anywhere in the kernel'.  This is out of date.  In linux/fs/proc/generic.c 
we find a very nice description of the parameters to read_func.  The 
appended patch replaces the bogus description with this (as far as I know) 
accurate one.
  --scott

Echelon KUGOWN COBRA JANE Mk 48 PANCHO mustard MKSEARCH RUCKUS fissionable
                          ( http://cscott.net/ )

diff -ruHpN -X dontdiff linux-2.6.22-rc5-orig/Documentation/DocBook/procfs-guide.tmpl linux-2.6.22-rc5/Documentation/DocBook/procfs-guide.tmpl
--- linux-2.6.22-rc5-orig/Documentation/DocBook/procfs-guide.tmpl	2007-06-16 22:09:12.000000000 -0400
+++ linux-2.6.22-rc5/Documentation/DocBook/procfs-guide.tmpl	2007-06-21 14:12:22.000000000 -0400
@@ -352,49 +352,93 @@ entry->write_proc = write_proc_foo;
        <funcsynopsis>
  	<funcprototype>
  	  <funcdef>int <function>read_func</function></funcdef>
-	  <paramdef>char* <parameter>page</parameter></paramdef>
+	  <paramdef>char* <parameter>buffer</parameter></paramdef>
  	  <paramdef>char** <parameter>start</parameter></paramdef>
  	  <paramdef>off_t <parameter>off</parameter></paramdef>
  	  <paramdef>int <parameter>count</parameter></paramdef>
-	  <paramdef>int* <parameter>eof</parameter></paramdef>
+	  <paramdef>int* <parameter>peof</parameter></paramdef>
  	  <paramdef>void* <parameter>data</parameter></paramdef>
  	</funcprototype>
        </funcsynopsis>

        <para>
          The read function should write its information into the
-        <parameter>page</parameter>. For proper use, the function
-        should start writing at an offset of
-        <parameter>off</parameter> in <parameter>page</parameter> and
-        write at most <parameter>count</parameter> bytes, but because
-        most read functions are quite simple and only return a small
-        amount of information, these two parameters are usually
-        ignored (it breaks pagers like <literal>more</literal> and
-        <literal>less</literal>, but <literal>cat</literal> still
-        works).
+        <parameter>buffer</parameter>, which will be exactly
+        <literal>PAGE_SIZE</literal> bytes long.
        </para>

        <para>
-        If the <parameter>off</parameter> and
-        <parameter>count</parameter> parameters are properly used,
-        <parameter>eof</parameter> should be used to signal that the
+        The parameter
+        <parameter>peof</parameter> should be used to signal that the
          end of the file has been reached by writing
          <literal>1</literal> to the memory location
-        <parameter>eof</parameter> points to.
+        <parameter>peof</parameter> points to.
        </para>

        <para>
-        The parameter <parameter>start</parameter> doesn't seem to be
-        used anywhere in the kernel. The <parameter>data</parameter>
+        The <parameter>data</parameter>
          parameter can be used to create a single call back function for
          several files, see <xref linkend="usingdata"/>.
        </para>

        <para>
-        The <function>read_func</function> function must return the
-        number of bytes written into the <parameter>page</parameter>.
+        The rest of the parameters and the return value are described
+	by a comment in <filename>fs/proc/generic.c</filename> as follows:
        </para>

+      <blockquote>
+        <para>
+	You have three ways to return data:
+       	</para>
+        <orderedlist>
+          <listitem>
+            <para>
+	      Leave <literal>*start = NULL</literal>.  (This is the default.)
+	      Put the data of the requested offset at that
+	      offset within the buffer.  Return the number (<literal>n</literal>)
+	      of bytes there are from the beginning of the
+	      buffer up to the last byte of data.  If the
+	      number of supplied bytes (<literal>= n - offset</literal>) is 
+	      greater than zero and you didn't signal eof
+	      and the reader is prepared to take more data
+	      you will be called again with the requested
+	      offset advanced by the number of bytes 
+	      absorbed.  This interface is useful for files
+	      no larger than the buffer.
+	    </para>
+	  </listitem>
+	  <listitem>
+            <para>
+	      Set <literal>*start</literal> to an unsigned long value less than
+	      the buffer address but greater than zero.
+	      Put the data of the requested offset at the
+	      beginning of the buffer.  Return the number of
+	      bytes of data placed there.  If this number is
+	      greater than zero and you didn't signal eof
+	      and the reader is prepared to take more data
+	      you will be called again with the requested
+	      offset advanced by <literal>*start</literal>.  This interface is
+	      useful when you have a large file consisting
+	      of a series of blocks which you want to count
+	      and return as wholes.
+	      (Hack by Paul.Russell@rustcorp.com.au)
+	    </para>
+	  </listitem>
+	  <listitem>
+            <para>
+	      Set <literal>*start</literal> to an address within the buffer.
+	      Put the data of the requested offset at <literal>*start</literal>.
+	      Return the number of bytes of data placed there.
+	      If this number is greater than zero and you
+	      didn't signal eof and the reader is prepared to
+	      take more data you will be called again with the
+	      requested offset advanced by the number of bytes
+	      absorbed.
+	    </para>
+	  </listitem>
+	</orderedlist>
+      </blockquote>
+
        <para>
          <xref linkend="example"/> shows how to use a read call back
          function.
