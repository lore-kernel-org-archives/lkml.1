Return-Path: <linux-kernel-owner+w=401wt.eu-S1752842AbYJ0BFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbYJ0BFl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 21:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYJ0BFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 21:05:31 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:5995 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbYJ0BFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 21:05:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CBaeHx30xq6dXrbDDRDqaPqOz2oo0XXX1h0jaPWokn3HnCwvBGhOYaW028xJhZpscS
         bvU2oYYrlEWvssIieDLKo8ohxYwGne1gwkhvQwSgj2qBM7FHycSgzPkXPn3fnbCQT70Y
         olN5M4YS51GNyYJa0bBGFpf916ZZq975q/Ers=
Message-ID: <490513D5.7080806@gmail.com>
Date: Mon, 27 Oct 2008 02:05:25 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] ftrace: Add a script to produce a hierarchical
 view of a function trace
References: <4904DF39.9070203@gmail.com> <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0810261903110.26269@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok it's corrected thanks to the trace sent by Steven.
Here is a V2.
---
From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] ftrace: Add a script to produce a hierarchical view of a function trace

This script parses a function trace and then produces a hierarchical view of the
function call stack after processing it into a tree.

Changes on V2:
_ Support both the files "trace" and "trace_pipe" (comments and space differences)
_ Correct the mini HOW-TO at the beginning.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
diff --git a/scripts/draw_functrace.py b/scripts/draw_functrace.py
new file mode 100755
index 0000000..4a45462
--- /dev/null
+++ b/scripts/draw_functrace.py
@@ -0,0 +1,130 @@
+#!/usr/bin/python
+
+"""
+Copyright 2008 (c) Frederic Weisbecker <fweisbec@gmail.com>
+Licensed under the terms of the GNU GPL License version 2
+
+This script parses a trace provided by the function tracer in
+kernel/trace/trace_functions.c
+The resulted trace is processed into a tree to produce a more human
+view of the call stack by drawing textual but hierarchical tree of
+calls. Only the functions's names and the the call time are provided.
+
+Usage:
+	Be sure that you have CONFIG_FUNCTION_TRACER
+	# mkdir /debugfs
+	# mount -t debug debug /debug
+	# echo function > /debug/tracing/current_tracer
+	$ cat /debug/tracing/trace_pipe > ~/raw_trace_func
+	Wait some times but not too much, the script is a bit slow.
+	Break the pipe (Ctrl + Z)
+	$ scripts/draw_functrace.py < raw_trace_func > draw_functrace
+	Then you have your drawn trace in draw_functrace
+"""
+
+
+import sys, re
+
+class CallTree:
+	""" This class provides a tree representation of the functions
+		call stack. If a function has no parent in the kernel (interrupt,
+		syscall, kernel thread...) then it is attached to a virtual parent
+		called ROOT.
+	"""
+	ROOT = None
+
+	def __init__(self, func, time = None, parent = None):
+		self._func = func
+		self._time = time
+		if parent is None:
+			self._parent = CallTree.ROOT
+		else:
+			self._parent = parent
+		self._children = []
+
+	def calls(self, func, calltime):
+		""" If a function calls another one, call this method to insert it
+			into the tree at the appropriate place.
+			@return: A reference to the newly created child node.
+		"""
+		child = CallTree(func, calltime, self)
+		self._children.append(child)
+		return child
+
+	def getParent(self, func):
+		""" Retrieve the last parent of the current node that
+			has the name given by func. If this function is not
+			on a parent, then create it as new child of root
+			@return: A reference to the parent.
+		"""
+		tree = self
+		while tree != CallTree.ROOT and tree._func != func:
+			tree = tree._parent
+		if tree == CallTree.ROOT:
+			child = CallTree.ROOT.calls(func, None)
+			return child
+		return tree
+
+	def __repr__(self):
+		return self.__toString("", True)
+
+	def __toString(self, branch, lastChild):
+		if self._time is not None:
+			s = "%s----%s (%s)\n" % (branch, self._func, self._time)
+		else:
+			s = "%s----%s\n" % (branch, self._func)
+
+		i = 0
+		if lastChild:
+			branch = branch[:-1] + " "
+		while i < len(self._children):
+			if i != len(self._children) - 1:
+				s += "%s" % self._children[i].__toString(branch +\
+								"    |", False)
+			else:
+				s += "%s" % self._children[i].__toString(branch +\
+								"    |", True)
+			i += 1
+		return s
+
+class BrokenLineException(Exception):
+	"""If the last line is not complete because of the pipe breakage,
+	   we want to stop the processing and ignore this line.
+	"""
+	pass
+
+class CommentLineException(Exception):
+	""" If the line is a comment (as in the beginning of the trace file),
+	    just ignore it.
+	"""
+	pass
+
+
+def parseLine(line):
+	line = line.strip()
+	if line.startswith("#"):
+		raise CommentLineException
+	m = re.match("[^]]+?\\] +([0-9.]+): (\\w+) <-(\\w+)", line)
+	if m is None:
+		raise BrokenLineException
+	return (m.group(1), m.group(2), m.group(3))
+
+
+def main():
+	CallTree.ROOT = CallTree("Root (Nowhere)", None, None)
+	tree = CallTree.ROOT
+
+	for line in sys.stdin:
+		try:
+			calltime, callee, caller = parseLine(line)
+		except BrokenLineException:
+			break
+		except CommentLineException:
+			continue
+		tree = tree.getParent(caller)
+		tree = tree.calls(callee, calltime)
+
+	print CallTree.ROOT
+
+if __name__ == "__main__":
+	main()
